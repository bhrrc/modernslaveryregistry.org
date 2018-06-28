require 'rails_helper'

RSpec.describe StatementStats do
  let! :software do
    Industry.create! name: 'Software'
  end

  let! :broadcasting do
    Industry.create! name: 'Broadcasting'
  end

  let! :retail do
    Industry.create! name: 'Retail'
  end

  let! :movies do
    Industry.create! name: 'Movies'
  end

  let! :gb do
    Country.create! code: 'GB', name: 'United Kingdom'
  end

  let! :uk_legislation do
    Legislation.create! name: 'UK Legislation', icon: 'uk'
  end

  let! :us_legislation do
    Legislation.create! name: 'US Legislation', icon: 'us'
  end

  let! :cucumber do
    Company.create! name: 'Cucumber Ltd', country: gb, industry: software
  end

  let! :bbc do
    Company.create! name: 'BBC Ltd', country: gb, industry: broadcasting
  end

  let! :itv do
    Company.create! name: 'ITV Ltd', country: gb, industry: broadcasting
  end

  let! :tesco do
    Company.create! name: 'Tesco Plc', country: gb, industry: retail
  end

  let! :pixar do
    Company.create! name: 'Pixar', country: gb, industry: movies
  end

  let! :cucumber_2016 do
    cucumber.statements.create!(
      url: 'http://cucumber.io/2016',
      approved_by: 'Aslak',
      approved_by_board: 'Yes',
      signed_by_director: false,
      link_on_front_page: true,
      date_seen: Date.parse('21 May 2016'),
      published: true,
      contributor_email: 'someone@somewhere.com',
      legislations: [uk_legislation]
    )
  end

  let! :cucumber_2017 do
    cucumber.statements.create!(
      url: 'http://cucumber.io/2017',
      approved_by: 'Aslak',
      approved_by_board: 'Yes',
      signed_by_director: false,
      link_on_front_page: true,
      date_seen: Date.parse('22 June 2017'),
      published: true,
      contributor_email: 'someone@somewhere.com',
      legislations: [uk_legislation]
    )
  end

  let! :bbc_2016 do
    bbc.statements.create!(
      url: 'http://bbc.io/2016',
      approved_by: 'Aslak',
      approved_by_board: 'Yes',
      signed_by_director: 'No',
      link_on_front_page: true,
      date_seen: Date.parse('20 May 2016'),
      published: true,
      contributor_email: 'someone@somewhere.com',
      legislations: [uk_legislation]
    )
  end

  let! :bbc_2017 do
    bbc.statements.create!(
      url: 'http://bbc.io/2017',
      approved_by: 'Aslak',
      approved_by_board: 'Yes',
      signed_by_director: 'No',
      link_on_front_page: true,
      date_seen: Date.parse('20 May 2017'),
      published: true,
      contributor_email: 'someone@somewhere.com',
      legislations: [uk_legislation, us_legislation]
    )
  end

  let! :pixar_2020 do
    pixar.statements.create!(
      url: 'http://pixar.io/2020',
      approved_by: 'Josh',
      approved_by_board: 'Yes',
      signed_by_director: 'No',
      link_on_front_page: true,
      date_seen: Date.parse('20 May 2020'),
      published: false,
      contributor_email: 'someone@somewhere.com',
      legislations: [us_legislation]
    )
  end

  let :stats do
    StatementStats.new
  end

  let :search do
    StatementSearch.new(false, {})
  end

  it 'counts published statements' do
    expect(stats.statements_count).to eq(4)
    # Verify that search count is consistent
    expect(search.statements.size).to eq(4)
  end

  it 'counts companies with published statements' do
    expect(stats.companies_count).to eq(2)
  end

  it 'counts industries of companies with published statements' do
    expect(stats.industries_count).to eq(2)
  end

  it 'groups counts of statements by month' do
    expect(stats.total_statements_over_time).to eq(
      [
        { label: 'May 2016', statements: 2 },
        { label: 'May 2017', statements: 3 },
        { label: 'June 2017', statements: 4 }
      ]
    )
  end
end
