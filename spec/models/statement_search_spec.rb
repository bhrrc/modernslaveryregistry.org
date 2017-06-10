require 'rails_helper'

RSpec.describe Statement, type: :model do
  let :software do
    Sector.create! name: 'Software'
  end

  let :agriculture do
    Sector.create! name: 'Agriculture'
  end

  let :gb do
    Country.create! code: 'GB', name: 'United Kingdom'
  end

  let :no do
    Country.create! code: 'NO', name: 'Norway'
  end

  let :cucumber do
    Company.create! name: 'Cucumber Ltd', country: gb, sector: software
  end

  let :potato do
    Company.create! name: 'Potato Ltd', country: no, sector: agriculture
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
      contributor_email: 'someone@somewhere.com'
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
      published: false,
      contributor_email: 'someone@somewhere.com'
    )
  end

  let! :potato_2016 do
    potato.statements.create!(
      url: 'http://potato.io/2016',
      approved_by: 'Aslak',
      approved_by_board: 'Yes',
      signed_by_director: 'No',
      link_on_front_page: true,
      date_seen: Date.parse('20 May 2016'),
      published: true,
      contributor_email: 'someone@somewhere.com'
    )
  end

  let! :potato_2017 do
    potato.statements.create!(
      url: 'http://potato.io/2017',
      approved_by: 'Aslak',
      approved_by_board: 'Yes',
      signed_by_director: 'No',
      link_on_front_page: true,
      date_seen: Date.parse('20 May 2017'),
      published: false,
      contributor_email: 'someone@somewhere.com'
    )
  end

  context 'when the searcher is an admin' do
    it 'finds latest statements ordered by company name' do
      search = Statement.search(admin: true, criteria: {})
      expect(search.statements).to eq([cucumber_2017, potato_2017])
    end
  end

  context 'when the searcher is not an admin' do
    it 'finds latest published statements ordered by company name' do
      search = Statement.search(admin: false, criteria: {})
      expect(search.statements).to eq([cucumber_2016, potato_2016])
    end
  end

  it 'filters statements by company name' do
    expect(Statement.search(admin: false, criteria: { company_name: 'cucum' }).statements).to eq([cucumber_2016])
  end

  it 'filters statements by countries' do
    expect(Statement.search(admin: true, criteria: { countries: [no.id] }).statements).to eq([potato_2017])
    expect(Statement.search(admin: false, criteria: { countries: [gb.id, no.id] }).statements).to eq(
      [cucumber_2016, potato_2016]
    )
  end

  it 'filters statements by company sectors' do
    expect(Statement.search(admin: true, criteria: { sectors: [agriculture.id] }).statements).to eq([potato_2017])
    expect(Statement.search(admin: false, criteria: { sectors: [agriculture.id, software.id] }).statements).to eq(
      [cucumber_2016, potato_2016]
    )
  end
end
