require 'rails_helper'

RSpec.describe StatementExport do
  let(:industry) { Industry.create! name: 'Software' }
  let(:country) { Country.create! code: 'GB', name: 'United Kingdom' }
  let(:company) { Company.create! name: 'Cucumber Ltd', country: country, industry: industry, company_number: '332211' }
  let(:company1) { Company.create! name: 'company-1' }
  let(:company2) { Company.create! name: 'company-2' }
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
                               published: true,
                               legislations: [uk_legislation],
                               first_year_covered: 2018,
                               last_year_covered: 2019)
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

    statement.additional_companies_covered << company1
    statement.additional_companies_covered << company2
  end

  describe 'to_csv' do
    it 'returns data relevant for exporting in a CSV format' do
      csv = StatementExport.to_csv(Company.all, true)
      header, data = CSV.parse(csv)
      expect(header).to match_array([
                                      'Company ID',
                                      'Company',
                                      'Is Publisher',
                                      'Statement ID',
                                      'URL',
                                      'Companies House Numbers',
                                      'Industry',
                                      'HQ',
                                      'Is Also Covered',
                                      Legislation::UK_NAME,
                                      Legislation::CALIFORNIA_NAME,
                                      'Period Covered',
                                      'Approved by Board',
                                      'Approved by',
                                      'Signed by Director',
                                      'Signed by',
                                      'Link on Front Page',
                                      'Published',
                                      'Verified by',
                                      'Contributed by',
                                      'Broken URL'
                                    ])
      expect(data).to match_array([
                                    statement.company_id.to_s,
                                    'Cucumber Ltd',
                                    'true',
                                    statement.id.to_s,
                                    'https://cucumber.io/',
                                    '332211',
                                    'Software',
                                    'United Kingdom',
                                    'true',
                                    'true',
                                    'false',
                                    '2018-2019',
                                    'Yes',
                                    'Big Boss',
                                    'false',
                                    'Little Boss',
                                    'true',
                                    'true',
                                    'admin@somewhere.com',
                                    'contributor@somewhere.com',
                                    'false'
                                  ])
    end

    it 'ommits admin-only information when the extra parameter is false' do
      csv = StatementExport.to_csv(Company.all, false)

      header, = CSV.parse(csv)

      expect(header).to match_array([
                                      'Company ID',
                                      'Company',
                                      'Is Publisher',
                                      'Statement ID',
                                      'URL',
                                      'Companies House Numbers',
                                      'Industry',
                                      'HQ',
                                      'Is Also Covered',
                                      Legislation::UK_NAME,
                                      Legislation::CALIFORNIA_NAME,
                                      'Period Covered'
                                    ])
    end

    it 'includes additional companies' do
      csv = StatementExport.to_csv(Company.where(id: company.id), true)
      data = CSV.parse(csv)
      expect(data[2]).to_not be_nil
      expect(data[2]).to match_array([
                                       company1.id.to_s,
                                       'company-1',
                                       'false',
                                       statement.id.to_s,
                                       'https://cucumber.io/',
                                       nil,
                                       'Industry unknown',
                                       'Country unknown',
                                       'true',
                                       'true',
                                       'false',
                                       '2018-2019',
                                       'Yes',
                                       'Big Boss',
                                       'false',
                                       'Little Boss',
                                       'true',
                                       'true',
                                       'admin@somewhere.com',
                                       'contributor@somewhere.com',
                                       'false'
                                     ])
    end
  end
end
