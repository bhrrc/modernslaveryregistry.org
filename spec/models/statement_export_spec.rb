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

  let(:uk_legislation) do
    Legislation.create! name: Legislation::UK_NAME, icon: 'uk'
  end

  let(:statement) do
    company.statements.create!(url: 'http://cucumber.io/',
                               approved_by: 'Big Boss',
                               approved_by_board: 'Yes',
                               signed_by_director: false,
                               signed_by: 'Little Boss',
                               link_on_front_page: true,
                               verified_by: user,
                               contributor_email: 'contributor@somewhere.com',
                               date_seen: Date.parse('2017-03-22'),
                               also_covers_companies: 'one,two,three',
                               published: true,
                               legislations: [uk_legislation])
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

    VCR.use_cassette('cucumber.io') do
      statement.fetch_snapshot
      statement.save!
    end
  end

  describe 'to_csv' do
    it 'turns rows into CSV' do
      csv = Statement.to_csv(company.statements.includes(company: %i[industry country]), false)

      header, data = CSV.parse(csv)

      expect(header).to eq([
                             'Company',
                             'URL',
                             'Industry',
                             'HQ',
                             'Also Covers Companies',
                             Legislation::UK_NAME,
                             Legislation::CALIFORNIA_NAME
                           ])
      expect(data).to eq([
                           'Cucumber Ltd',
                           'https://cucumber.io/',
                           'Software',
                           'United Kingdom',
                           'one,two,three',
                           'true',
                           'false'
                         ])
    end

    it 'adds additional fields when extra parameter is true' do
      csv = Statement.to_csv(company.statements.includes(company: %i[industry country]), true)

      header, data = CSV.parse(csv)

      expect(header).to eq([
                             'Company',
                             'URL',
                             'Industry',
                             'HQ',
                             'Also Covers Companies',
                             Legislation::UK_NAME,
                             Legislation::CALIFORNIA_NAME,
                             'Approved by Board',
                             'Approved by',
                             'Signed by Director',
                             'Signed by',
                             'Link on Front Page',
                             'Published',
                             'Verified by',
                             'Contributed by',
                             'Broken URL',
                             'Company ID'
                           ])
      expect(data).to eq([
                           'Cucumber Ltd',
                           'https://cucumber.io/',
                           'Software',
                           'United Kingdom',
                           'one,two,three',
                           'true',
                           'false',
                           'Yes',
                           'Big Boss',
                           'false',
                           'Little Boss',
                           'true',
                           'true',
                           'admin@somewhere.com',
                           'contributor@somewhere.com',
                           'false',
                           statement.company_id.to_s
                         ])
    end
  end
end
