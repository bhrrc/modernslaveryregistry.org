Given(/^the following statements have been submitted:$/) do |table|
  table.hashes.each do |props|
    submit_statement props
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

When(/^(Joe|Patricia|Vicky) submits the following statement:$/) do |actor, table|
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
      .contributor_email(props['contributor_email'])
  )
end

When(/^(Joe|Patricia) updates the statement for "([^"]*)" to:$/) do |actor, company_name, table|
  actor.attempts_to(UpdateStatement.for_company(company_name).with_new_values(table))
end

When(/^(Joe|Patricia) deletes the statement for "([^"]*)"$/) do |actor, company_name|
  actor.attempts_to(DeleteStatement.for_company(company_name))
end

When(/^(Joe|Patricia) finds all statements by "([^"]*)"$/) do |actor, company_name|
  actor.attempts_to(FindAllStatementsByCompany.for_company(company_name))
end

Then(/^(Joe|Patricia) should see (\d+) statements? for "([^"]*)"$/) do |actor, statement_count, company_name|
  expect(actor.to_see(TheListedStatements.for_company(company_name)).length).to eq(statement_count.to_i)
end

Then(/^(Joe|Patricia) should see the following statements:$/) do |actor, table|
  expect(actor.to_see(TheStatementsByCompany.all).map(&:date_seen)).to eq(table.hashes.map { |row| row['date_seen'] })
end

Then(/(Joe|Patricia) should only see "([^"]*)" in the search results$/) do |actor, company_names_string|
  company_names = company_names_string.split(',').map(&:strip)
  expect(actor.to_see(TheListedStatements.from_search).map(&:company_name)).to eq(company_names)
end

Then(/^(Joe|Patricia) should see that the newest statement for "([^"]*)" was verified by herself$/) do |actor, company_name|
  expect(actor.to_see(TheNewestStatement.for_company(company_name)).verified_by).to eq(actor.name)
end

Then(/^(Joe|Patricia) should see that the newest statement for "([^"]*)" was contributed by (.*)$/) do |actor, company_name, contributor_email|
  contributor_email = User.find_by!(first_name: actor.name).email if contributor_email == 'herself'
  expect(actor.to_see(TheNewestStatement.for_company(company_name)).contributor_email).to eq(contributor_email)
end

Then(/^(Joe|Patricia) should see that the newest statement for "([^"]*)" is not published$/) do |actor, company_name|
  expect(actor.to_see(TheNewestStatement.for_company(company_name)).published).to eq('Draft')
end

Then(/^(Joe|Patricia) should see that the newest statement for "([^"]*)" was not verified$/) do |actor, company_name|
  expect(actor.to_see(TheNewestStatement.for_company(company_name)).verified_by).to eq(nil)
end

Then(/^(Joe|Patricia) should see that no statement for "([^"]*)" exists$/) do |actor, company_name|
  expect(actor.to_see(TheNewestStatement.for_company(company_name))).to be_nil
end

Then(/^(Joe|Patricia) should see that the statement was invalid and not saved$/) do |actor|
  expect(actor.to_see(ValidationErrors.bullet_points)).to eq(["Statements url can't be blank"])
end

class SubmitStatement < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    fill_in_statement_form(browser)
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
    @country = 'United Kingdom'
    @new_company = new_company
    @signed_by_director = 'No'
    @approved_by_board = 'No'
    @link_on_front_page = 'No'
    @published = 'No'
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

  def contributor_email(value)
    @contributor_email = value
    self
  end

  private

  def fill_in_statement_form(browser)
    visit_form(browser)
    browser.fill_in('Statement URL', with: @url)

    choose_option(browser, 'link_on_front_page', @link_on_front_page)
    choose_option(browser, 'signed_by_director', @signed_by_director)
    choose_option(browser, 'approved_by_board', @approved_by_board)

    unless @published.nil?
      @published =~ /yes|true/i ? browser.check('Published?') : browser.uncheck('Published?')
    end

    browser.fill_in('Your email', with: @contributor_email) unless @contributor_email.nil?
  end

  def visit_form(browser)
    if @new_company
      browser.visit(new_company_statement_companies_path)
      browser.fill_in('Company name', with: @company_name)
      browser.select(@country, from: 'Company HQ') if @country
    else
      company = Company.find_by(name: @company_name)
      browser.visit(new_company_statement_path(company))
    end
  end

  def choose_option(browser, option_name, option_value)
    return if option_value.nil?
    browser.within %([data-content="#{option_name}"]) do
      browser.choose(option_value)
    end
  end
end

class UpdateStatement < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    company = Company.find_by(name: @company_name)
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

class FindAllStatementsByCompany < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)

    company = Company.find_by(name: @company_name)
    browser.visit(company_path(company))
  end

  def self.for_company(company_name)
    new(company_name)
  end

  def initialize(company_name)
    @company_name = company_name
  end
end

class DeleteStatement < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)

    company = Company.find_by(name: @company_name)
    browser.visit(company_statement_path(company, company.newest_statement))
    browser.click_on 'Delete'
  end

  def self.for_company(company_name)
    new(company_name)
  end

  def initialize(company_name)
    @company_name = company_name
  end
end

class TheNewestStatement < Fellini::Question
  include Fellini::Capybara::DomStruct
  include Rails.application.routes.url_helpers

  def answered_by(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)

    company = Company.find_by(name: @company_name)
    return nil if company.newest_statement.nil?
    browser.visit(company_statement_path(company, company.newest_statement))

    struct(browser, :statement, :verified_by, :contributor_email, :published)
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
    @proc&.call(browser)
    structs(browser, :statement, *@struct_fields)
  end

  def initialize(struct_fields, &proc)
    @struct_fields = struct_fields
    @proc = proc
  end

  def self.from_search
    new(%i[company_name sector country])
  end

  def self.for_company(company_name)
    new([:date_seen]) do |browser|
      browser.visit(company_path(Company.find_by!(name: company_name)))
    end
  end
end

class TheStatementsByCompany < Fellini::Question
  include Fellini::Capybara::DomStruct

  def answered_by(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    structs(browser, :statement, :date_seen)
  end

  def self.all
    new
  end
end

class ValidationErrors < Fellini::Question
  include Fellini::Capybara::DomStruct

  def answered_by(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    structs(browser, :validation_errors, :validation_error).map(&:validation_error)
  end

  def self.bullet_points
    new
  end
end
