require "rails_helper"

RSpec.describe Sector, :type => :model do
  before do
    software = Sector.create! name: 'Software'
    agriculture = Sector.create! name: 'Agriculture'
    gb = Country.create! code: 'GB', name: 'United Kingdom'
    Company.create!({
      name: 'Cucumber Ltd',
      country_id: gb.id,
      sector_id: agriculture.id
    })
  end

  it "reports number of sectors with companies" do
    expect(Sector.with_companies.all.length).to eq(1)
  end
end
