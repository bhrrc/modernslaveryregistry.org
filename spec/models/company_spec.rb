require 'rails_helper'

RSpec.describe Company, type: :model do
  it 'destroys orphaned child statements when the company is deleted' do
    company = Company.create!(name: 'company-name')
    statement = company.statements.create!(url: 'http://example.com')

    company.destroy

    expect { statement.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

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

  it 'uses last_year_covered to determine the latest statement' do
    company = Company.create!(name: 'company-name')
    company.statements.create!(last_year_covered: 2018, url: 'http://older-statement')
    newer_statement = company.statements.create!(last_year_covered: 2019, url: 'http://newer-statement')

    expect(company.latest_statement).to eq(newer_statement)
  end

  it 'uses date_seen to determine the latest statement when last_year_covered is identical' do
    company = Company.create!(name: 'company-name')
    company.statements.create!(date_seen: Date.parse('2019-01-01'),
                               last_year_covered: 2019,
                               url: 'http://seen-less-recently')
    newer_statement = company.statements.create!(date_seen: Date.parse('2019-02-01'),
                                                 last_year_covered: 2019,
                                                 url: 'http://seen-more-recently')

    expect(company.latest_statement).to eq(newer_statement)
  end
end
