require 'rails_helper'

RSpec.describe Statement, type: :model do
  describe 'marking latest statement' do
    it 'marks the statement for the latest year covered' do
      company = Company.create!(name: 'company-name')
      earliest_statement = company.statements.create!(
        last_year_covered: 2016,
        date_seen: 1.day.ago,
        url: 'http://example.com'
      )
      latest_statement = company.statements.create!(
        last_year_covered: 2017,
        date_seen: 2.days.ago,
        url: 'http://example.com'
      )

      expect(earliest_statement.reload).not_to be_latest
      expect(latest_statement.reload).to be_latest
    end

    it 'marks the statement seen most recently' do
      company = Company.create!(name: 'company-name')
      earliest_statement = company.statements.create!(
        last_year_covered: 2017,
        date_seen: 2.days.ago,
        url: 'http://example.com'
      )
      latest_statement = company.statements.create!(
        last_year_covered: 2017,
        date_seen: 1.day.ago,
        url: 'http://example.com'
      )

      expect(earliest_statement.reload).not_to be_latest
      expect(latest_statement.reload).to be_latest
    end
  end

  describe 'marking latest published statement' do
    it 'marks the published statement for the latest year covered' do
      company = Company.create!(name: 'company-name')
      latest_published_statement = company.statements.create!(
        last_year_covered: 2016,
        url: 'http://example.com',
        published: true
      )
      earliest_published_statement = company.statements.create!(
        last_year_covered: 2015,
        url: 'http://example.com',
        published: true
      )
      latest_statement = company.statements.create!(
        last_year_covered: 2017,
        url: 'http://example.com',
        published: false
      )

      expect(earliest_published_statement.reload).not_to be_latest_published
      expect(latest_statement.reload).not_to be_latest_published
      expect(latest_published_statement.reload).to be_latest_published
    end

    it 'marks the published statement seen most recently' do
      company = Company.create!(name: 'company-name')
      earliest_published_statement = company.statements.create!(
        last_year_covered: 2017,
        date_seen: 3.days.ago,
        url: 'http://example.com',
        published: true
      )
      latest_published_statement = company.statements.create!(
        last_year_covered: 2017,
        date_seen: 2.days.ago,
        url: 'http://example.com',
        published: true
      )
      latest_statement = company.statements.create!(
        last_year_covered: 2017,
        date_seen: 1.day.ago,
        url: 'http://example.com',
        published: false
      )

      expect(earliest_published_statement.reload).not_to be_latest_published
      expect(latest_statement.reload).not_to be_latest_published
      expect(latest_published_statement.reload).to be_latest_published
    end
  end

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
      @company = Company.create! name: 'Cucumber Ltd', country: @gb, industry: @sw
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

    it 'turns rows into CSV' do
      VCR.use_cassette('cucumber.io') do
        user = User.create!(first_name: 'Someone',
                            last_name: 'Smith',
                            email: 'someone@somewhere.com',
                            password: 'whatevs')

        statement = @company.statements.create!(url: 'http://cucumber.io/',
                                                approved_by: 'Big Boss',
                                                approved_by_board: 'Yes',
                                                signed_by_director: false,
                                                link_on_front_page: true,
                                                verified_by: user,
                                                date_seen: Date.parse('2017-03-22'),
                                                also_covers_companies: 'one,two,three',
                                                published: true)

        statement.fetch_snapshot
        statement.save!
        csv = Statement.to_csv(@company.statements.includes(company: %i[industry country]), false)

        expect(csv).to eq(<<~CSV
          Company,URL,Industry,HQ,Date Added,Also Covers Companies
          Cucumber Ltd,https://cucumber.io/,Software,United Kingdom,2017-03-22,"one,two,three"
        CSV
                         )
      end
    end

    it 'turns rows into CSV with more columns for admins' do
      VCR.use_cassette('cucumber.io') do
        user = User.create!(first_name: 'Super',
                            last_name: 'Admin',
                            email: 'admin@somewhere.com',
                            password: 'whatevs',
                            admin: true)

        statement = @company.statements.create!(url: 'http://cucumber.io/',
                                                approved_by: 'Big Boss',
                                                approved_by_board: 'Yes',
                                                signed_by_director: false,
                                                signed_by: 'Little Boss',
                                                link_on_front_page: true,
                                                verified_by: user,
                                                contributor_email: 'contributor@somewhere.com',
                                                date_seen: Date.parse('2017-03-22'),
                                                published: true)

        statement.fetch_snapshot
        statement.save!
        csv = Statement.to_csv(@company.statements.includes(company: %i[industry country]), true)

        expect(csv).to eq(<<~CSV
          Company,URL,Industry,HQ,Date Added,Also Covers Companies,Approved by Board,Approved by,Signed by Director,Signed by,Link on Front Page,Published,Verified by,Contributed by,Broken URL,Company ID
          Cucumber Ltd,https://cucumber.io/,Software,United Kingdom,2017-03-22,,Yes,Big Boss,false,Little Boss,true,true,admin@somewhere.com,contributor@somewhere.com,false,#{statement.company_id}
        CSV
                         )
      end
    end
  end
end
