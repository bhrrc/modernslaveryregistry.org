require "rails_helper"

RSpec.describe Statement, :type => :model do
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
      date_seen: Date.parse('21 May 2016'),
      published: true,
      contributor_email: 'someone@somewhere.com'
    })
    @p2016 = @company_potato.statements.create!({
      url: 'http://potato.io/2016',
      approved_by: 'Aslak',
      approved_by_board: 'Yes',
      signed_by_director: 'No',
      link_on_front_page: true,
      date_seen: Date.parse('20 May 2016'),
      published: false,
      contributor_email: 'someone@somewhere.com'
    })
    @c2017 = @company_cucumber.statements.create!({
      url: 'http://cucumber.io/2017',
      approved_by: 'Aslak',
      approved_by_board: 'Yes',
      signed_by_director: false,
      link_on_front_page: true,
      date_seen: Date.parse('22 June 2017'),
      published: false,
      contributor_email: 'someone@somewhere.com'
    })
  end

  it 'can be searched by company name' do
    statements = Statement.search(nil, company_name: 'cucumber')
    expect(statements).to eq([@c2016])
  end

  it "lists most recent statements" do
    statements = Statement.includes(:company).all.newest
    expect(statements).to eq([@c2017, @p2016])
  end

  it "lists most recent published statements" do
    statements = Statement.includes(:company).all.newest.published
    expect(statements).to eq([@c2016])
  end

  it 'is searchable by company name' do
    statements = Statement.joins(:company).where("LOWER(name) LIKE LOWER(?)", "%ucumber%")
    expect(statements).to eq([@c2016, @c2017])
  end

  it 'is searchable by company name and published status' do
    statements = Statement.published.includes(:company)
      .joins(:company).where("LOWER(name) LIKE LOWER(?)", "%ucumber%")
    expect(statements).to eq([@c2016])
  end

  it 'is filterable by company sector' do
    statements = Statement.includes(:company)
      .joins(:company).where(companies: {sector_id: @sw.id})
    expect(statements).to eq([@c2016, @c2017])
  end

  it 'is filterable by company sector and published status' do
    statements = Statement.published.includes(:company)
      .joins(:company).where(companies: {sector_id: @sw.id})
    expect(statements).to eq([@c2016])
  end

  it 'is filterable by company sector and published status, listing only newest' do
    statements = Statement.newest.published.includes(:company)
      .joins(:company).where(companies: {sector_id: @sw.id})
    expect(statements).to eq([@c2016])
  end

  it 'is filterable by country' do
    statements = Statement.newest.published.includes(:company)
      .joins(:company).where(companies: {country_id: @gb.id})
    expect(statements).to eq([@c2016])
  end

  it 'is filterable by country and sector' do
    statements = Statement.newest.published.includes(:company)
      .joins(:company).where(companies: {
        country_id: @gb.id,
        sector_id: @sw.id
      })
    expect(statements).to eq([@c2016])
  end

  it 'is filterable by company name, country and sector' do
    statements = Statement.newest.published.includes(:company)
      .joins(:company)
      .where("LOWER(name) LIKE LOWER(?)", "%ucumber%")
      .where(companies: {
        country_id: @gb.id,
        sector_id: @sw.id
      })
    expect(statements).to eq([@c2016])
  end

  it 'is filterable by company name, country and sector (no hits)' do
    statements = Statement.newest.published.includes(:company)
      .joins(:company)
      .where("LOWER(name) LIKE LOWER(?)", "%WAT%")
      .where(companies: {
        country_id: @gb.id,
        sector_id: @sw.id
      })
    expect(statements).to eq([])
  end
end
