require "rails_helper"

RSpec.describe Statement, :type => :model do
  before do
    gb = Country.create! code: 'GB', name: 'United Kingdom'
    @company_cucumber = Company.create! name: 'Cucumber Ltd', country_id: gb.id
    @company_potato = Company.create! name: 'Potato Ltd', country_id: gb.id
  end

  it "lists all companies with most recent statement" do
    c2016 = @company_cucumber.statements.create!({
      url: 'http://cucumber.io/2016',
      approved_by: 'Aslak',
      approved_by_board: 'Yes',
      signed_by_director: false,
      link_on_front_page: true,
      date_seen: Date.parse('21 May 2016')
    })
    p2016 = @company_potato.statements.create!({
      url: 'http://potato.io/2016',
      approved_by: 'Aslak',
      approved_by_board: 'Yes',
      signed_by_director: 'No',
      link_on_front_page: true,
      date_seen: Date.parse('20 May 2016')
    })
    c2017 = @company_cucumber.statements.create!({
      url: 'http://cucumber.io/2017',
      approved_by: 'Aslak',
      approved_by_board: 'Yes',
      signed_by_director: false,
      link_on_front_page: true,
      date_seen: Date.parse('22 June 2017')
    })

    companies = Company.includes(:newest_statement).all
    statements = companies.map{|c| c.newest_statement}.sort do |s1, s2|
      s1.date_seen <=> s2.date_seen
    end
    expect(statements).to eq([p2016, c2017])
  end
end
