require 'rails_helper'

RSpec.describe StatementExport do
  let(:industry) { Industry.create! name: 'Software' }
  let(:country) { Country.create! code: 'GB', name: 'United Kingdom' }
  let(:company) { Company.create! name: 'Cucumber Ltd', country: country, industry: industry }
  let(:user) do
    User.create!(first_name: 'Super',
                 last_name: 'Admin',
                 email: 'admin@somewhere.com',
                 password: 'whatevs',
                 admin: true)
  end

  before do
    allow(ScreenGrab).to receive(:fetch) do |url|
      FetchResult.with(
        url: url,
        broken_url: false,
        content_type: 'image/jpeg',
        content_data: 'image data!'
      )
    end
  end

  describe 'to_csv' do
    it 'turns rows into CSV' do
      VCR.use_cassette('cucumber.io') do
        statement = company.statements.create!(url: 'http://cucumber.io/',
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
        csv = Statement.to_csv(company.statements.includes(company: %i[industry country]), false)

        expect(csv).to eq(<<~CSV
          Company,URL,Industry,HQ,Also Covers Companies
          Cucumber Ltd,https://cucumber.io/,Software,United Kingdom,"one,two,three"
        CSV
                         )
      end
    end

    it 'turns rows into CSV with more columns for admins' do
      VCR.use_cassette('cucumber.io') do
        statement = company.statements.create!(url: 'http://cucumber.io/',
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
        csv = Statement.to_csv(company.statements.includes(company: %i[industry country]), true)

        expect(csv).to eq(<<~CSV
          Company,URL,Industry,HQ,Also Covers Companies,Approved by Board,Approved by,Signed by Director,Signed by,Link on Front Page,Published,Verified by,Contributed by,Broken URL,Company ID
          Cucumber Ltd,https://cucumber.io/,Software,United Kingdom,,Yes,Big Boss,false,Little Boss,true,true,admin@somewhere.com,contributor@somewhere.com,false,#{statement.company_id}
        CSV
                         )
      end
    end
  end
end
