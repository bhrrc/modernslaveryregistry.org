require 'rails_helper'

RSpec.describe Country, type: :model do
  before do
    sector = Sector.create! name: 'Software'
    Country.create! code: 'NO', name: 'Norway'
    gb = Country.create! code: 'GB', name: 'United Kingdom'
    Country.create! code: 'FR', name: 'France'
    Company.create!(name: 'Cucumber Ltd',
                    country_id: gb.id,
                    sector_id: sector.id)
  end

  it 'reports number of countries with companies' do
    expect(Country.with_companies.all.length).to eq(1)
  end
end
