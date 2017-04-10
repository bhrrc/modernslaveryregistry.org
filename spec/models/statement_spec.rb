require "rails_helper"

RSpec.describe Statement, :type => :model do
  before do
    @sw = Sector.create! name: 'Software'
    @gb = Country.create! code: 'GB', name: 'United Kingdom'
    @company = Company.create! name: 'Cucumber Ltd', country_id: @gb.id, sector_id: @sw.id
  end

  it "converts url to https if it exists" do
    statement = @company.statements.create!({
      url: 'http://cucumber.io/',
      approved_by: 'Aslak',
      approved_by_board: 'Yes',
      signed_by_director: false,
      link_on_front_page: true,
      date_seen: Date.parse('21 May 2016')
    })

    expect(statement.url).to eq('https://cucumber.io/')
  end
end
