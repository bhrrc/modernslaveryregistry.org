require "rails_helper"

RSpec.describe Company, :type => :model do
  before do
    @sw = Sector.create! name: 'Software'
    @ag = Sector.create! name: 'Agriculture'
    @gb = Country.create! code: 'GB', name: 'United Kingdom'
    @no = Country.create! code: 'NO', name: 'Norway'
    @company_cucumber = Company.create! name: 'Cucumber Ltd', country_id: @gb.id, sector_id: @sw.id
    @company_potato = Company.create! name: 'Potato Ltd', country_id: @gb.id, sector_id: @ag.id
    @c2016 = @company_cucumber.statements.create!({
      url: 'http://cucumber.io/2016',
      approved_by: 'Aslak',
      approved_by_board: 'Yes',
      signed_by_director: false,
      link_on_front_page: true,
      date_seen: Date.parse('21 May 2016')
    })
    @p2016 = @company_potato.statements.create!({
      url: 'http://potato.io/2016',
      approved_by: 'Aslak',
      approved_by_board: 'Yes',
      signed_by_director: 'No',
      link_on_front_page: true,
      date_seen: Date.parse('20 May 2016')
    })
    @c2017 = @company_cucumber.statements.create!({
      url: 'http://cucumber.io/2017',
      approved_by: 'Aslak',
      approved_by_board: 'Yes',
      signed_by_director: false,
      link_on_front_page: true,
      date_seen: Date.parse('22 June 2017')
    })
  end

  it "lists all companies with most recent statement" do
    companies = Company.includes(:newest_statement).all
    statements = companies.map{|c| c.newest_statement}.sort do |s1, s2|
      s1.date_seen <=> s2.date_seen
    end
    expect(statements).to eq([@p2016, @c2017])
  end

  it 'is searchable by name' do
    companies = Company.search(company_name: 'cucumber')
    expect(companies).to eq([@company_cucumber])
  end

  it 'is filterable by sector' do
    companies = Company.search(sectors: [@sw.id])
    expect(companies).to eq([@company_cucumber])
  end

  it 'is filterable by company' do
    companies = Company.search(countries: [@gb.id])
    expect(companies).to eq([@company_cucumber, @company_potato])
  end

  it 'is filterable by company and sector' do
    companies = Company.search(countries: [@no.id], sectors: [@sw.id])
    expect(companies).to eq([])
  end
end
