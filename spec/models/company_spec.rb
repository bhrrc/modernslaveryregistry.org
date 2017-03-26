require "rails_helper"

RSpec.describe Statement, :type => :model do
  before do
    @company_cucumber = Company.create! name: 'Cucumber Ltd'
    @company_potato = Company.create! name: 'Potato Ltd'
  end

  it "lists all companies with most recent statement" do
    c1 = @company_cucumber.statements.create!({
      url: 'https://cucumber.io/statement',
      date_seen: Date.parse('21 May 2016')
    })
    p1 = @company_potato.statements.create!({
      url: 'https://potato.io/statement',
      date_seen: Date.parse('20 May 2016')
    })
    c2 = @company_cucumber.statements.create!({
      url: 'https://cucumber.io/statement',
      date_seen: Date.parse('22 June 2017')
    })

    companies = Company.includes(:newest_statement).all
    expect(companies.map{|c| c.newest_statement}).to eq([c2, p1])
  end
end
