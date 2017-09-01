Given(/^the following statements have been submitted:$/) do |table|
  table.hashes.each do |props|
    submit_statement props.symbolize_keys
  end
end

Given(/^a statement was submitted for "([^"]*)" that responds with a 404$/) do |company_name|
  statement_url = 'https://cucumber.io/some-404'
  allow(StatementUrl).to receive(:fetch).with(statement_url).and_return(
    FetchResult.with(
      url: statement_url,
      broken_url: true,
      content_type: 'text/plain',
      content_data: 'ooooops! nothing here...'
    )
  )
  submit_statement(
    statement_url: statement_url,
    company_name: company_name
  )
end

When(/^(Joe|Patricia) submits the following statement for "([^"]*)":$/) do |actor, company_name, table|
  actor.attempts_to_submit_new_statement_for_existing_company(
    company_name: company_name,
    options: table.rows_hash.symbolize_keys
  )
end

Given(/^(Joe|Patricia) has submitted the following statement:$/) do |actor, table|
  actor.attempts_to_create_company_with_statement(options: table.rows_hash.symbolize_keys)
end

When(/^(Joe|Patricia|Vicky) submits the following statement:$/) do |actor, table|
  actor.attempts_to_create_company_with_statement(options: table.rows_hash.symbolize_keys)
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

When(/^(Joe|Patricia) marks the URL for "([^"]*)" as not broken$/) do |actor, company_name|
  url = Company.find_by!(name: company_name).latest_statement.url
  allow(ScreenGrab).to receive(:fetch).with(url).and_return(
    FetchResult.with(
      url: url,
      broken_url: false,
      content_data: "image/jpeg snapshot for statement by 'Cucumber Ltd'",
      content_type: 'image/png'
    )
  )
  actor.attempts_to_mark_statement_url_as_not_broken(company_name: company_name)
end

Then(/^(Joe|Patricia) should see 1 statement for "([^"]*)" with:$/) do |actor, company_name, table|
  statements = actor.visible_listed_statements_for_company(company_name: company_name)
  expect(statements.length).to eq(1)
  latest = actor.visible_latest_statement_by_company(company_name: company_name)
  attrs = table.rows_hash.symbolize_keys
  attrs.each do |attr, value|
    expect("#{attr}=#{latest.send(attr)}").to eq("#{attr}=#{value}")
  end
end

Then(/^(Joe|Patricia) should see (\d+) statements? for "([^"]*)"$/) do |actor, statement_count, company_name|
  expect(actor.visible_listed_statements_for_company(company_name: company_name).length).to eq(statement_count.to_i)
end

Then(/^(Joe|Patricia) should see the following statements:$/) do |actor, table|
  expect(actor.visible_listed_statements_with_date_seen.map(&:date_seen)).to eq(table.hashes.map { |row| row['date_seen'] })
end

Then(/(Joe|Patricia) should only see "([^"]*)" in the search results$/) do |actor, company_names_string|
  company_names = company_names_string.split(',').map(&:strip)
  expect(actor.visible_listed_company_names_from_search).to eq(company_names)
end

Then(/^(Joe|Patricia) should see that the latest statement for "([^"]*)" was verified by herself$/) do |actor, company_name|
  expect(actor.visible_latest_statement_by_company(company_name: company_name).verified_by).to eq(actor.name)
end

Then(/^(Joe|Patricia) should see that the latest statement for "([^"]*)" was contributed by (.*)$/) do |actor, company_name, contributor_email|
  contributor_email = User.find_by!(first_name: actor.name).email if contributor_email == 'herself'
  expect(actor.visible_latest_statement_by_company(company_name: company_name).contributor_email).to eq(contributor_email)
end

Then(/^(Joe|Patricia) should see that the latest statement for "([^"]*)" is not published$/) do |actor, company_name|
  expect(actor.visible_latest_statement_by_company(company_name: company_name).published).to eq('No')
end

Then(/^(Joe|Patricia) should see that the latest statement for "([^"]*)" was not verified$/) do |actor, company_name|
  expect(actor.visible_latest_statement_by_company(company_name: company_name).verified_by).to eq(nil)
end

Then(/^(Joe|Patricia) should see that no statement for "([^"]*)" exists$/) do |actor, company_name|
  expect(actor.visible_count_of_statements_by_company(company_name: company_name)).to eq(0)
end

Then(/^(Joe|Patricia) should see that the statement was invalid and not saved$/) do |actor|
  expect(actor.visible_validation_error_summary).to eq(["Url can't be blank"])
end

module SubmitsStatementsAsVisitor
  def attempts_to_create_company_with_statement(options:)
    visit new_company_path
    fill_in 'Company name', with: options.fetch(:company_name)
    fill_in 'Statement URL', with: options.fetch(:url)
    fill_in 'Your email', with: options.fetch(:contributor_email)
    select options[:country], from: 'Company HQ' if options[:country]
    click_button 'Submit'
  end

  def attempts_to_submit_new_statement_for_existing_company(company_name:, options:)
    company = Company.find_by!(name: company_name)
    visit company_path(company)
    click_on "Submit a new statement by #{company_name}"
    fill_in_fields(options)
    click_button 'Create Statement'
  end
end

module SubmitsStatementsAsAdmin
  def attempts_to_create_company_with_statement(options:)
    visit new_admin_company_path
    fill_in_fields(options)
    click_button 'Create Company'
  end

  def attempts_to_submit_new_statement_for_existing_company(company_name:, options:)
    company = Company.find_by!(name: company_name)
    visit new_admin_company_statement_path(company)
    fill_in_fields(options)
    click_button 'Create Statement'
  end

  private

  def fill_in_fields(options)
    options.symbolize_keys.each do |option, value|
      fill_in_field(option, value)
    end
  end

  def fill_in_field(option, value)
    if text_field_labels.include?(option)
      fill_in(text_field_labels[option], with: value)
    elsif drop_downs.include?(option)
      select(value, from: drop_downs[option])
    elsif check_boxes.include?(option)
      value =~ /yes|true/i ? check(check_boxes[option]) : uncheck(check_boxes[option])
    elsif radios.include?(option)
      within("*[data-content='#{radios[option]}']") do
        choose(value)
      end
    else
      raise "Don't know how to fill in field '#{option}'"
    end
  end

  def text_field_labels
    {
      company_name: 'Name',
      url: 'Url'
    }
  end

  def drop_downs
    {
      country: 'Country'
    }
  end

  def check_boxes
    {
      signed_by_director: 'Signed by director?',
      link_on_front_page: 'Link on front page?',
      published: 'Published?'
    }
  end

  def radios
    {
      approved_by_board: 'Approved by board'
    }
  end
end

module UpdatesStatements
  def attempts_to_update_statement(company_name:, new_values:)
    company = Company.find_by!(name: company_name)
    visit admin_company_statement_path(company, company.latest_statement)
    click_link 'Edit Statement'
    fill_in_fields(new_values)
    click_button 'Update Statement'
  end

  def attempts_to_mark_statement_url_as_not_broken(company_name:)
    company = Company.find_by!(name: company_name)
    visit admin_company_statement_path(company, company.latest_statement)
    click_on 'Mark URL not broken'
  end
end

module DeletesStatements
  include Rails.application.routes.url_helpers

  def attempts_to_delete_latest_statement_by_company(company_name:)
    company = Company.find_by(name: company_name)
    visit admin_company_statement_path(company, company.latest_statement)
    click_on 'Delete Statement'
  end
end

module ViewsStatements
  def attempts_to_find_all_statements_by_company(company_name:)
    company = Company.find_by!(name: company_name)
    visit company_path(company)
  end

  def visible_latest_statement_by_company(company_name:)
    company = Company.find_by!(name: company_name)
    raise "#{company.name} has no latest statement!" if company.latest_statement.nil?
    visit admin_company_statement_path(company, company.latest_statement)
    dom_struct(:statement, :url, :verified_by, :contributor_email,
               :published, :signed_by_director, :approved_by_board, :link_on_front_page)
  end

  def visible_listed_company_names_from_search
    visible_listed_companies_from_search.map(&:name)
  end

  def visible_listed_companies_from_search
    within "*[data-content='company_search_results']" do
      dom_structs(:company, :name, :sector, :country)
    end
  end

  def visible_listed_statements_for_company(company_name:)
    visit(company_path(Company.find_by!(name: company_name)))
    visible_listed_statements_with_date_seen
  end

  def visible_count_of_statements_by_company(company_name:)
    visible_listed_statements_for_company(company_name:company_name).size
  end

  def visible_listed_statements_with_date_seen
    visible_company_statements_list_structs(%i[date_seen])
  end

  private

  def visible_company_statements_list_structs(struct_fields)
    dom_structs(:company_statements_list, *struct_fields)
  end
end

module SeesValidationErrors
  def visible_validation_error_summary
    dom_structs(:validation_errors, :validation_error).map(&:validation_error)
  end
end

class Visitor
  include SubmitsStatementsAsVisitor
  include ViewsStatements
  include SeesValidationErrors
end

class Administrator
  include SubmitsStatementsAsAdmin
  include UpdatesStatements
  include DeletesStatements
end
