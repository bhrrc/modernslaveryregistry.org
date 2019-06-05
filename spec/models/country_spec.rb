require 'rails_helper'

RSpec.describe Country, type: :model do
  before do
    industry = Industry.create! name: 'Software'
    Country.create! code: 'NO', name: 'Norway'
    gb = Country.create! code: 'GB', name: 'United Kingdom'
    Country.create! code: 'FR', name: 'France'
    Company.create!(name: 'Cucumber Ltd',
                    country_id: gb.id,
                    sector_id: industry.id, company_number: '44556')
  end

  it 'reports number of countries with companies' do
    expect(Country.with_companies.all.length).to eq(1)
  end

  specify 'Company number should be unique' do
    company = Company.create!(name: 'company-name', company_number: '123456')
    company2 = company.dup
    assert !company2.valid?
  end

  specify 'Check Company number Presence only if Country name should be United Kingdom and Industry name not equl to Charity/Non-Profit OR Public Entities ' do
    country = Country.find_by(code: 'GB')
    industry = Industry.create!(name: 'Energy Equipment & Services')
    company = Company.new(name: 'company-name', industry_id: industry.id, country_id: country.id)
    assert company.required_country?
  end

  specify 'Not Required Company Number Only if Country name not equal to United Kingdom and Industry name equl to Charity/Non-Profit OR Public Entities ' do
    country = Country.find_by(code: 'NO')
    industry = Industry.create!(name: 'Charity/Non-Profit')
    company = Company.new(name: 'company-name', country_id: country.id, industry_id: industry.id)
    assert !company.required_country?
  end
end
