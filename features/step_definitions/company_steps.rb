Given(/^the company "([^"]*)" has been submitted$/) do |company_name|
  Company.create!(
    name: company_name,
    country: Country.find_or_create_by!(code: 'GB', name: 'United Kingdom')
  )
end

When(/^(Joe|Patricia) submits the company "([^"]*)"$/) do |actor, company_name|
  actor.attempts_to_create_company(name: company_name)
end

When(/^(Vicky) submits the following company:$/) do |actor, table|
  details = table.rows_hash
  actor.attempts_to_submit_company_with_statement(
    name: details.fetch('Company name'),
    statement_url: details.fetch('Statement URL'),
    your_email: details.fetch('Your email')
  )
end

When(/^(Joe|Patricia) deletes the company "([^"]*)"$/) do |actor, company_name|
  actor.attempts_to_delete_company(company_name: company_name)
end

Then(/^(Joe|Patricia) should see company "([^"]*)"$/) do |actor, company_name|
  expect(actor.visible_company_name).to eq(company_name)
end

Then(/^(Joe|Patricia) should find company "([^"]*)"$/) do |actor, company_name|
  actor.attempts_to_search_for company_name
  expect(actor.visible_company_name).to eq(company_name)
end

module AttemptsToCreateCompany
  def attempts_to_create_company(name:)
    visit new_admin_company_path
    fill_in 'Name', with: name
    select 'United Kingdom', from: 'Country'
    select 'Software', from: 'Sector'
    click_button 'Create Company'
  end
end

module AttemptsToSubmitCompanyWithStatement
  def attempts_to_submit_company_with_statement(name:, statement_url:, your_email:)
    visit new_company_path
    fill_in 'Company name', with: name
    fill_in 'Statement URL', with: statement_url
    fill_in 'Your email', with: your_email
    click_button 'Submit'
  end
end

module AttemptsToDeleteCompany
  def attempts_to_delete_company(company_name:)
    company = Company.find_by!(name: company_name)
    visit admin_company_path(company)
    click_button 'Delete Company'
  end
end

module SeesACompanyOnThePage
  def visible_company_name
    find('[data-content="company"] [data-content="name"]').text
  end
end

class Visitor
  include AttemptsToSubmitCompanyWithStatement
  include SeesACompanyOnThePage
end

class Administrator
  include AttemptsToCreateCompany
  include AttemptsToDeleteCompany
end
