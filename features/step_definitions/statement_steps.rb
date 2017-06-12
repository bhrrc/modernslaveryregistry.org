Given(/^the following statements have been submitted:$/) do |table|
  table.hashes.each do |props|
    submit_statement props
  end
end

When(/^(Joe|Patricia) submits the following statement for "([^"]*)":$/) do |actor, company_name, table|
  props = table.rows_hash
  actor.attempts_to_submit_statement(
    new_company: false,
    company_name: company_name,
    url: props['url'],
    signed_by_director: props['signed_by_director'],
    approved_by_board: props['approved_by_board'],
    link_on_front_page: props['link_on_front_page']
  )
end

Given(/^(Joe|Patricia) has submitted the following statement:$/) do |actor, table|
  # TODO: remove duplication
  props = table.rows_hash
  actor.attempts_to_submit_statement(
    new_company: true,
    company_name: props['company_name'],
    url: props['url'],
    signed_by_director: props['signed_by_director'],
    approved_by_board: props['approved_by_board'],
    link_on_front_page: props['link_on_front_page'],
    published: props['published']
  )
end

When(/^(Joe|Patricia|Vicky) submits the following statement:$/) do |actor, table|
  props = table.rows_hash
  actor.attempts_to_submit_statement(
    new_company: true,
    company_name: props['company_name'],
    url: props['url'],
    signed_by_director: props['signed_by_director'],
    approved_by_board: props['approved_by_board'],
    link_on_front_page: props['link_on_front_page'],
    published: props['published'],
    contributor_email: props['contributor_email']
  )
end

When(/^(Joe|Patricia) updates the statement for "([^"]*)" to:$/) do |actor, company_name, table|
  actor.attempts_to_update_statement(company_name: company_name, new_values: table.rows_hash)
end

When(/^(Joe|Patricia) deletes the statement for "([^"]*)"$/) do |actor, company_name|
  actor.attempts_to_delete_latest_statement_by_company(company_name: company_name)
end

When(/^(Joe|Patricia) finds all statements by "([^"]*)"$/) do |actor, company_name|
  actor.attempts_to_find_all_statements_by_company(company_name: company_name)
end

Then(/^(Joe|Patricia) should see (\d+) statements? for "([^"]*)"$/) do |actor, statement_count, company_name|
  expect(actor.visible_listed_statements_for_company(company_name: company_name).length).to eq(statement_count.to_i)
end

Then(/^(Joe|Patricia) should see the following statements:$/) do |actor, table|
  expect(actor.visible_listed_statements_with_date_seen.map(&:date_seen)).to eq(table.hashes.map { |row| row['date_seen'] })
end

Then(/(Joe|Patricia) should only see "([^"]*)" in the search results$/) do |actor, company_names_string|
  company_names = company_names_string.split(',').map(&:strip)
  expect(actor.visible_listed_statements_from_search.map(&:company_name)).to eq(company_names)
end

Then(/^(Joe|Patricia) should see that the latest statement for "([^"]*)" was verified by herself$/) do |actor, company_name|
  expect(actor.visible_latest_statement_by_company(company_name: company_name).verified_by).to eq(actor.name)
end

Then(/^(Joe|Patricia) should see that the latest statement for "([^"]*)" was contributed by (.*)$/) do |actor, company_name, contributor_email|
  contributor_email = User.find_by!(first_name: actor.name).email if contributor_email == 'herself'
  expect(actor.visible_latest_statement_by_company(company_name: company_name).contributor_email).to eq(contributor_email)
end

Then(/^(Joe|Patricia) should see that the latest statement for "([^"]*)" is not published$/) do |actor, company_name|
  expect(actor.visible_latest_statement_by_company(company_name: company_name).published).to eq('Draft')
end

Then(/^(Joe|Patricia) should see that the latest statement for "([^"]*)" was not verified$/) do |actor, company_name|
  expect(actor.visible_latest_statement_by_company(company_name: company_name).verified_by).to eq(nil)
end

Then(/^(Joe|Patricia) should see that no statement for "([^"]*)" exists$/) do |actor, company_name|
  expect(actor.visible_latest_statement_by_company(company_name: company_name)).to be_nil
end

Then(/^(Joe|Patricia) should see that the statement was invalid and not saved$/) do |actor|
  expect(actor.visible_validation_error_summary).to eq(["Statements url can't be blank"])
end

module SubmitsStatements
  def attempts_to_submit_statement(options)
    visit_form(options)
    fill_in_form(options)
    click_button 'Submit'
  end

  private

  def visit_form(options)
    new_company = options.fetch(:new_company)
    if new_company
      visit new_company_statement_companies_path
      fill_in 'Company name', with: options.fetch(:company_name)
      select options[:country], from: 'Company HQ' if options[:country]
    else
      company = Company.find_by(name: options.fetch(:company_name))
      visit new_company_statement_path(company)
    end
  end

  def fill_in_form(options)
    fill_in 'Statement URL', with: options.fetch(:url)

    %i[link_on_front_page signed_by_director approved_by_board].each do |option|
      choose_option(option, options.fetch(option))
    end

    unless options[:published].nil?
      options[:published] =~ /yes|true/i ? check('Published?') : uncheck('Published?')
    end

    fill_in('Your email', with: options[:contributor_email]) if options[:contributor_email]
  end

  def choose_option(option_name, option_value)
    return if option_value.nil?
    within %([data-content="#{option_name}"]) do
      choose(option_value)
    end
  end
end

module UpdatesStatements
  def attempts_to_update_statement(company_name:, new_values:)
    company = Company.find_by!(name: company_name)
    visit company_statement_path(company, company.latest_statement)
    click_link 'Edit'
    fill_in('Company name', with: new_values.fetch('company_name'))
    click_button 'Submit'
  end
end

module DeletesStatements
  include Rails.application.routes.url_helpers

  def attempts_to_delete_latest_statement_by_company(company_name:)
    company = Company.find_by(name: company_name)
    visit company_statement_path(company, company.latest_statement)
    click_on 'Delete'
  end
end

module ViewsStatements
  def attempts_to_find_all_statements_by_company(company_name:)
    company = Company.find_by!(name: company_name)
    visit company_path(company)
  end

  def visible_latest_statement_by_company(company_name:)
    company = Company.find_by(name: company_name)
    return nil if company.latest_statement.nil?
    visit company_statement_path(company, company.latest_statement)

    dom_struct(:statement, :verified_by, :contributor_email, :published)
  end

  def visible_listed_statements_from_search
    visible_listed_statements_structs %i[company_name sector country]
  end

  def visible_listed_statements_for_company(company_name:)
    visit(company_path(Company.find_by!(name: company_name)))
    visible_listed_statements_with_date_seen
  end

  def visible_listed_statements_with_date_seen
    visible_listed_statements_structs %i[date_seen]
  end

  private

  def visible_listed_statements_structs(struct_fields)
    dom_structs(:statement, *struct_fields)
  end
end

module SeesValidationErrors
  def visible_validation_error_summary
    dom_structs(:validation_errors, :validation_error).map(&:validation_error)
  end
end

class Visitor
  include SubmitsStatements
  include ViewsStatements
  include SeesValidationErrors
end

class Administrator
  include UpdatesStatements
  include DeletesStatements
end
