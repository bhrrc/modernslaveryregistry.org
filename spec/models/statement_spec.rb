require 'rails_helper'

RSpec.describe Statement, type: :model do
  describe 'validation' do
    it 'disallows invalid URLs' do
      statement = Statement.new(url: '\\')
      expect(statement).to_not be_valid
      expect(statement.errors[:url]).to eq(['is not a valid URL'])
    end
  end

  describe '#url_exists?' do
    it 'returns true for http when https exists' do
      company = Company.create!(name: 'BigCorp')
      company.statements.create!(url: 'https://host.com')
      expect(Statement.url_exists?('http://host.com')).to eq(true)
    end

    it 'returns true for https when http exists' do
      company = Company.create!(name: 'BigCorp')
      company.statements.create!(url: 'http://host.com')
      expect(Statement.url_exists?('https://host.com')).to eq(true)
    end
  end

  describe 'fetching snapshots' do
    before do
      allow(ScreenGrab).to receive(:fetch) do |url|
        FetchResult.with(
          url: url,
          broken_url: false,
          content_type: 'image/jpeg',
          content_data: 'image data!'
        )
      end
      @sw = Industry.create! name: 'Software'
      @vegetables = Industry.create!(name: 'Vegetables')
      @gb = Country.create! code: 'GB', name: 'United Kingdom'
      @company = Company.create! name: 'Cucumber Ltd', country: @gb, industry: @sw, company_number: '332211'
    end

    it 'uses active storage to save a screenshot of the statement' do
      VCR.use_cassette('cucumber.io') do
        statement = @company.statements.create!(url: 'http://cucumber.io/',
                                                approved_by: 'Big Boss',
                                                approved_by_board: 'Yes',
                                                signed_by_director: false,
                                                link_on_front_page: true,
                                                date_seen: Date.parse('21 May 2016'),
                                                contributor_email: 'anon@host.com')
        statement.fetch_snapshot
        expect(statement.snapshot.screenshot).to be_attached
      end
    end

    it 'does not store a screenshot if image generation fails' do
      url = 'http://cucumber.io/'

      original_fetch_result = FetchResult.with(
        url: url, broken_url: false,
        content_type: 'text/html', content_data: 'original'
      )
      screenshot_fetch_result = FetchResult.with(
        url: url, broken_url: true,
        content_type: nil, content_data: nil
      )
      allow(StatementUrl).to receive(:fetch).with(url).and_return(original_fetch_result)
      allow(ScreenGrab).to receive(:fetch).with(url).and_return(screenshot_fetch_result)

      statement = @company.statements.create!(url: url)
      statement.fetch_snapshot
      expect(statement.snapshot.screenshot).not_to be_attached
    end

    it 'uses active storage to save the original of the statement' do
      VCR.use_cassette('cucumber.io') do
        statement = @company.statements.create!(url: 'http://cucumber.io/',
                                                approved_by: 'Big Boss',
                                                approved_by_board: 'Yes',
                                                signed_by_director: false,
                                                link_on_front_page: true,
                                                date_seen: Date.parse('21 May 2016'),
                                                contributor_email: 'anon@host.com')
        statement.fetch_snapshot
        expect(statement.snapshot.original).to be_attached
      end
    end

    it 'converts url to https if it exists' do
      VCR.use_cassette('cucumber.io') do
        statement = @company.statements.create!(url: 'http://cucumber.io/',
                                                approved_by: 'Big Boss',
                                                approved_by_board: 'Yes',
                                                signed_by_director: false,
                                                link_on_front_page: true,
                                                date_seen: Date.parse('21 May 2016'),
                                                contributor_email: 'anon@host.com')
        statement.fetch_snapshot
        expect(statement.url).to eq('https://cucumber.io/')
      end
    end

    it 'does not validate admin-only visible fields for non-admins' do
      VCR.use_cassette('cucumber.io') do
        statement = @company.statements.create(url: 'http://cucumber.io/',
                                               verified_by: nil,
                                               contributor_email: 'anon@host.com')

        statement.fetch_snapshot
        expect(statement.errors.messages).to eq({})
      end
    end

    it 'validates admin-only visible fields for admins' do
      VCR.use_cassette('cucumber.io') do
        user = User.create!(first_name: 'Super',
                            last_name: 'Admin',
                            email: 'admin@somewhere.com',
                            password: 'whatevs',
                            admin: true)

        legislation = Legislation.create!(
          name: 'Silly sausage act',
          icon: 'me',
          requires_statement_attributes: 'approved_by_board'
        )

        statement = @company.statements.create(url: 'http://cucumber.io/',
                                               verified_by: user,
                                               contributor_email: 'somebody@host.com',
                                               legislations: [legislation],
                                               published: true)

        expect(statement.errors.messages).to eq(approved_by_board: ["can't be blank"])
      end
    end
  end

  it 'can apply to other companies' do
    company1 = Company.create!(name: 'company-1')
    company2 = Company.create!(name: 'company-2')
    company1_statement = company1.statements.create!(url: 'http://example.com')
    company1_statement.additional_companies_covered << company2

    expect(company1_statement.additional_companies_covered).to include(company2)
  end

  describe '#additional_companies_covered_excluding' do
    it 'excludes the company passed to the method' do
      company1 = Company.create!(name: 'company1')
      company2 = Company.create!(name: 'company2')
      statement = company1.statements.create!(url: 'http://example.com')
      statement.additional_companies_covered << company2

      expect(statement.additional_companies_covered_excluding(company2)).to be_empty
    end

    it 'sorts the companies alphabetically' do
      company1 = Company.create!(name: 'company1')
      company_z = Company.create!(name: 'company-z')
      company_a = Company.create!(name: 'company-a')
      statement = company1.statements.create!(url: 'http://example.com')
      statement.additional_companies_covered << company_z
      statement.additional_companies_covered << company_a

      companies = statement.additional_companies_covered_excluding(Company.new)
      expect(companies).to eq([company_a, company_z])
    end
  end

  describe '#published_by?' do
    it 'returns true if the company matches the publishing company' do
      publishing_company = Company.create!(name: 'publishing-company')
      statement = publishing_company.statements.create!(url: 'http://example.com')

      expect(statement.published_by?(publishing_company)).to be(true)
    end

    it 'returns false if the company does not match the publishing company' do
      publishing_company = Company.create!(name: 'publishing-company')
      other_company = Company.create!(name: 'other-company')
      statement = publishing_company.statements.create!(url: 'http://example.com')

      expect(statement.published_by?(other_company)).to be(false)
    end
  end

  describe '#also_covers_companies' do
    let(:company) { Company.create!(name: 'company') }
    let(:statement) { company.statements.create!(url: 'http://example.com') }

    context 'when the statement is not associated with other companies' do
      it 'returns an empty array' do
        expect(statement.also_covers_companies).to eq([])
      end
    end

    context 'when the statement covers other companies' do
      let(:other_company1) { Company.create!(name: 'other-company-1') }
      let(:other_company2) { Company.create!(name: 'other-company-2') }

      before do
        statement.additional_companies_covered << other_company1
        statement.additional_companies_covered << other_company2
      end

      it 'returns an array of the names of companies also associated with this statement' do
        expect(statement.also_covers_companies).to contain_exactly('other-company-1', 'other-company-2')
      end
    end
  end

  describe '#also_covered?"' do
    let(:company) { Company.create!(name: 'company') }
    let(:statement) { company.statements.create!(url: 'http://example.com') }

    context 'when the statement is not associated with other companies' do
      it 'returns false' do
        actual = statement.also_covered?
        expect(actual).to be false
      end
    end

    context 'when the statement covers other companies' do
      let(:other_company1) { Company.create!(name: 'other-company-1') }
      let(:other_company2) { Company.create!(name: 'other-company-2') }

      before do
        statement.additional_companies_covered << other_company1
        statement.additional_companies_covered << other_company2
      end
      it 'returns true' do
        actual = statement.also_covered?
        expect(actual).to be true
      end
    end
  end

  describe '#also_covered_and_published_by?"' do
    let(:company) { Company.create!(name: 'company') }
    let(:statement) { company.statements.create!(url: 'http://example.com') }

    context 'when company is the publisher' do
      context 'and the statement is not associated with other companies (aka additional_companies is empty)' do
        it 'returns false' do
          actual = statement.also_covered_and_published_by?(company)
          expect(actual).to be false
        end
      end

      context 'and the statement covers other companies' do
        let(:other_company1) { Company.create!(name: 'other-company-1') }
        let(:other_company2) { Company.create!(name: 'other-company-2') }

        before do
          statement.additional_companies_covered << other_company1
          statement.additional_companies_covered << other_company2
        end

        it 'returns false' do
          actual = statement.also_covered_and_published_by?(company)
          expect(actual).to be false
        end
      end
    end

    context 'when company is not the publisher' do
      let(:company1) { Company.create!(name: 'company-1') }

      context 'and the statement is not associated with other companies' do
        it 'returns false' do
          actual = statement.also_covered_and_published_by?(company1)
          expect(actual).to be false
        end
      end

      context 'and the statement covers other companies' do
        let(:other_company1) { Company.create!(name: 'other-company-1') }
        let(:other_company2) { Company.create!(name: 'other-company-2') }

        before do
          statement.additional_companies_covered << other_company1
          statement.additional_companies_covered << other_company2
        end

        it 'returns true' do
          actual = statement.also_covered_and_published_by?(company1)
          expect(actual).to be true
        end
      end
    end
  end

  describe '#should_use_override_url?' do
    context 'when the statement has an `override_url`' do
      let(:company) { Company.create!(name: 'company') }
      let(:statement_with_override) { company.statements.create!(url: 'http://example.com', override_url: 'http://example.com/override') }
  
      it 'returns `true`' do
        expect(statement_with_override.should_use_override_url?).to be true
      end
    end

    context 'when the statement does not have an `override_url` (e.g., !override_url.blank?)' do
      let(:company_no_override) { Company.create!(name: 'company-no-override') }
      let(:statement_no_override) { company_no_override.statements.create!(url: 'http://example.com') }

      it 'returns `false`' do
        expect(statement_no_override.should_use_override_url?).to be false
      end
    end
  end
end
