require 'rails_helper'

RSpec.describe Company, type: :model do
  it 'orders statements by the last year covered' do
    company = Company.create!(name: 'company-name')
    earliest_statement = company.statements.create!(
      last_year_covered: 2014,
      url: 'http://example.com'
    )
    latest_statement = company.statements.create!(
      last_year_covered: 2017,
      url: 'http://example.com'
    )

    expect(company.statements).to eq([latest_statement, earliest_statement])
  end

  it 'orders statements by the date seen if last year covered is the same' do
    company = Company.create!(name: 'company-name')
    earliest_statement = company.statements.create!(
      last_year_covered: 2017,
      date_seen: 2.days.ago,
      url: 'http://example.com'
    )
    latest_statement = company.statements.create!(
      last_year_covered: 2017,
      date_seen: 1.day.ago,
      url: 'http://example.com'
    )

    expect(company.statements).to eq([latest_statement, earliest_statement])
  end
end
