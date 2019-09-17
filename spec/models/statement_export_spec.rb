require 'rails_helper'

RSpec.describe StatementExport do
  let(:industry) { Industry.create! name: 'Software' }
  let(:country) { Country.create! code: 'GB', name: 'United Kingdom' }
  let(:country1) { Country.create! code: 'US', name: 'United States' }
  let(:company) { Company.create! name: 'Cucumber Ltd', country: country, industry: industry, company_number: '332211' }
  let(:company1) { Company.create! name: 'company-1', country: country1 }
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
    statement.additional_companies_covered << company1
    statement.additional_companies_covered << company2
  end

  describe '.export' do
    it 'returns an array of statement values' do
      fields = { company_name: 'Company Name' }
      data = StatementExport.export(statement, fields)
      expect(data).to eq([statement.send(:company_name)])
    end

    it 'returns the companys country' do
      fields = { country_name: 'HQ' }
      data = StatementExport.export(statement, fields)
      expect(data).to eq([statement.send(:country_name)])
    end

    context 'when the context is set' do
      it 'returns values specific to the context' do
        fields = { company_name: 'Company Name' }
        data = StatementExport.export(statement, fields, context: company1)
        expect(data).to eq([company1.name])
      end

      context 'and the fields is country_name' do
        it 'returns the associated companys country' do
          fields = { country_name: 'HQ' }
          data = StatementExport.export(statement, fields, context: company1)
          expect(data).to eq([company1.country_name])
        end
      end

      context 'and the fields is company_id' do
        it 'returns the associated companys id' do
          fields = { company_id: 'Company ID' }
          data = StatementExport.export(statement, fields, context: company1)
          expect(data).to eq([company1.id])
        end
      end
    end
  end
end
