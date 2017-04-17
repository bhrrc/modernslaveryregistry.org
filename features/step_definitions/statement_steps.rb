Given(/^the following statements have been submitted:$/) do |table|
  table.hashes.each do |props|
    sector = Sector.find_by_name!(props['sector'])
    country = Country.find_by_name!(props['country'])
    company = Company.find_or_create_by!(
      name: props['company_name'],
      sector_id: sector.id,
      country_id: country.id
    )

    verified_by_user = nil
    unless props['verified_by'].empty?
      verified_by_user = User.find_by_first_name(props['verified_by']) || User.create!({
        first_name: props['verified_by'],
        email: "#{props['verified_by']}@host.com",
        password: 'whatevs'
      })
    end

    company.statements.create!(
      url: props['statement_url'],
      signed_by_director: 'No',
      approved_by_board: 'Not explicit',
      link_on_front_page: 'No',
      verified_by: verified_by_user,
      published: !verified_by_user.nil?
    )
  end
end

When(/^(Joe|Patricia) submits the following statement for "([^"]*)":$/) do |actor, company_name, table|
  props = table.rows_hash
  actor.attempts_to(
    SubmitStatement
      .for_existing_company(company_name)
      .with_statement_url(props['url'])
      .signed_by_director(props['signed_by_director'])
      .approved_by_board(props['approved_by_board'])
      .link_on_front_page(props['link_on_front_page'])
  )
end

Given(/^(Joe|Patricia) has submitted the following statement:$/) do |actor, table|
  # TODO: remove duplication
  props = table.rows_hash
  actor.attempts_to(
    SubmitStatement
      .for_new_company(props['company_name'])
      .in_country(props['country'])
      .with_statement_url(props['url'])
      .signed_by_director(props['signed_by_director'])
      .approved_by_board(props['approved_by_board'])
      .link_on_front_page(props['link_on_front_page'])
      .published(props['published'])
  )
end

When(/^(Joe|Patricia) submits the following statement:$/) do |actor, table|
  props = table.rows_hash
  actor.attempts_to(
    SubmitStatement
      .for_new_company(props['company_name'])
      .in_country(props['country'])
      .with_statement_url(props['url'])
      .signed_by_director(props['signed_by_director'])
      .approved_by_board(props['approved_by_board'])
      .link_on_front_page(props['link_on_front_page'])
      .published(props['published'])
  )
end

When(/^(Joe|Patricia) updates the statement for "([^"]*)" to:$/) do |actor, company_name, table|
  actor.attempts_to(UpdateStatement
    .for_company(company_name)
    .with_new_values(table))
end

Then(/^(Joe|Patricia) should see (\d+) statements? for "([^"]*)"$/) do |actor, statement_count, company_name|
  expect(actor.to_see(TheListedStatements.for_company(company_name)).length).to eq(statement_count.to_i)
end

Then(/(Joe|Patricia) should only see "([^"]*)" in the search results$/) do |actor, company_names_string|
  company_names = company_names_string.split(",").map(&:strip)
  expect(actor.to_see(TheListedStatements.from_search).map(&:company_name)).to eq(company_names)
end

Then(/^(Joe|Patricia) should see that the newest statement for "([^"]*)" was verified by herself$/) do |actor, company_name|
  expect(actor.to_see(TheNewestStatement.for_company(company_name)).verified_by).to eq(actor.name)
end

Then(/^(Joe|Patricia) should see that the newest statement for "([^"]*)" is not published$/) do |actor, company_name|
  expect(actor.to_see(TheNewestStatement.for_company(company_name)).published).to eq("Draft")
end

Then(/^(Joe|Patricia) should see that the newest statement for "([^"]*)" was not verified$/) do |actor, company_name|
  expect(actor.to_see(TheNewestStatement.for_company(company_name)).verified_by).to eq(nil)
end

class SubmitStatement < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)

    if(@new_company)
      browser.visit(new_company_statement_companies_path)
      browser.fill_in('Company name', with: @company_name)
      browser.select(@country, from: 'Company HQ')
    else
      company = Company.find_by_name(@company_name)
      browser.visit(new_company_statement_path(company))
    end
    browser.fill_in('Statement URL', with: @url)

    browser.within('[data-content="link_on_front_page"]') do
      browser.choose(@link_on_front_page)
    end
    browser.within('[data-content="signed_by_director"]') do
      browser.choose(@signed_by_director)
    end
    browser.within('[data-content="approved_by_board"]') do
      browser.choose(@approved_by_board)
    end

    @published =~ /yes|true/i ? browser.check('Published?') : browser.uncheck('Published?')

    browser.click_button 'Submit'
  end

  def self.for_new_company(company_name)
    instrumented(self, company_name, true)
  end

  def self.for_existing_company(company_name)
    instrumented(self, company_name, false)
  end

  def initialize(company_name, new_company)
    @company_name = company_name
    @country = "United Kingdom"
    @new_company = new_company
    @signed_by_director = "No"
    @approved_by_board = "No"
    @link_on_front_page = "No"
    @published = "No"
  end

  def in_country(country)
    @country = country
    self
  end

  def with_statement_url(url)
    @url = url
    self
  end

  def signed_by_director(value)
    @signed_by_director = value
    self
  end

  def approved_by_board(value)
    @approved_by_board = value
    self
  end

  def link_on_front_page(value)
    @link_on_front_page = value
    self
  end

  def published(value)
    @published = value
    self
  end
end

class UpdateStatement < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    company = Company.find_by_name(@company_name)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    browser.visit(company_statement_path(company, company.newest_statement))
    browser.click_link('Edit')

    values = @values_table.rows_hash
    browser.fill_in('Company name', with: values['company_name'])
    browser.click_button 'Submit'
  end

  def self.for_company(company_name)
    instrumented(self, company_name)
  end

  def initialize(company_name)
    @company_name = company_name
  end

  def with_new_values(values_table)
    @values_table = values_table
    self
  end
end

class TheNewestStatement < Fellini::Question
  include Fellini::Capybara::DomStruct
  include Rails.application.routes.url_helpers

  def answered_by(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)

    company = Company.find_by_name(@company_name)
    browser.visit(company_statement_path(company, company.newest_statement))

    struct(browser, :statement, :verified_by, :published)
  end

  def self.for_company(company_name)
    new(company_name)
  end

  def initialize(company_name)
    @company_name = company_name
  end
end

class TheListedStatements < Fellini::Question
  include Fellini::Capybara::DomStruct
  class << self
    include Rails.application.routes.url_helpers
  end

  def answered_by(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    @proc.call(browser) if @proc
    structs(browser, :statement, *@struct_fields)
  end

  def initialize(struct_fields, &proc)
    @struct_fields = struct_fields
    @proc = proc
  end

  def self.from_search
    new([:company_name, :sector, :country])
  end

  def self.for_company(company_name)
    new([:date_seen]) do |browser|
      browser.visit(company_path(Company.find_by_name!(company_name)))
    end
  end
end
