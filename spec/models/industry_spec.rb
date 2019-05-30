require 'rails_helper'

RSpec.describe Industry, type: :model do
  before do
    @software = Industry.create! name: 'Software'
    @agriculture = Industry.create! name: 'Agriculture'
    @retail = Industry.create! name: 'Retail'
    @gb = Country.create! code: 'GB', name: 'United Kingdom'
    @fr = Country.create! code: 'FR', name: 'France'
  end

  it 'reports number of industries with companies' do
    Company.find_or_create_by(industry_id: @agriculture.id, name: 'Cucumber Ltd', country_id: @gb.id, company_number: '112233')
    expect(Industry.with_companies.all.length).to eq(1)
  end

  it 'reports countries in each industry' do
    Company.create!(industry_id: @agriculture.id, name: 'Ag1', country_id: @gb.id, company_number: '221122')
    Company.create!(industry_id: @agriculture.id, name: 'Ag2', country_id: @fr.id)
    Company.create!(industry_id: @agriculture.id, name: 'Ag3', country_id: @gb.id, company_number: '332211')
    Company.create!(industry_id: @software.id, name: 'Sw1', country_id: @gb.id, company_number: '432211')

    industries = Industry.with_companies.with_company_counts.order('company_count DESC').all
    expect(industries.map(&:company_count)).to eq([3, 1])
  end
end
