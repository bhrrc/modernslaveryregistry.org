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
                                                published: true)

        statement.fetch_snapshot
        statement.save!
        csv = Statement.to_csv(@company.statements.includes(company: %i[industry country]), false)

        expect(csv).to eq(<<~CSV
          Company,URL,Industry,HQ,Date Added
          Cucumber Ltd,https://cucumber.io/,Software,United Kingdom,2017-03-22
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
          Company,URL,Industry,HQ,Date Added,Approved by Board,Approved by,Signed by Director,Signed by,Link on Front Page,Published,Verified by,Contributed by,Broken URL,Company ID
          Cucumber Ltd,https://cucumber.io/,Software,United Kingdom,2017-03-22,Yes,Big Boss,false,Little Boss,true,true,admin@somewhere.com,contributor@somewhere.com,false,#{statement.company_id}
        CSV
                         )
      end
    end
  end
end
