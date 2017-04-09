require "rails_helper"

RSpec.describe Sector, :type => :model do
  before do
    @software = Sector.create! name: 'Software'
    @agriculture = Sector.create! name: 'Agriculture'
    @retail = Sector.create! name: 'Retail'
    @gb = Country.create! code: 'GB', name: 'United Kingdom'
    @fr = Country.create! code: 'FR', name: 'France'
  end

  it "reports number of sectors with companies" do
    Company.create!({sector_id: @agriculture.id, name: 'Cucumber Ltd', country_id: @gb.id})
    expect(Sector.with_companies.all.length).to eq(1)
  end

  it "reports countries in each sector" do
    Company.create!({sector_id: @agriculture.id, name: 'Ag1', country_id: @gb.id})
    Company.create!({sector_id: @agriculture.id, name: 'Ag2', country_id: @fr.id})
    Company.create!({sector_id: @agriculture.id, name: 'Ag3', country_id: @gb.id})
    Company.create!({sector_id: @software.id, name: 'Sw1', country_id: @gb.id})

    sectors = Sector.with_companies.with_company_counts.order('company_count DESC').all
    expect(sectors.map(&:company_count)).to eq([3, 1])
  end
end
