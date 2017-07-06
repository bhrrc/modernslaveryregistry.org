Given(/^company "([^"]*)" has been submitted$/) do |company_name|
  Company.create!(
    name: company_name,
    country: Country.find_or_create_by!(code: 'GB', name: 'United Kingdom')
  )
end

When(/^(Joe|Patricia) submits company "([^"]*)"$/) do |actor, company_name|
  actor.attempts_to_submit_company(name: company_name)
end

When(/^(Vicky) submits the following company:$/) do |actor, table|
  details = table.rows_hash
  actor.attempts_to_submit_company_as_visitor(
    name: details.fetch('Company name'),
    statement_url: details.fetch('Statement URL'),
    your_email: details.fetch('Your email')
  )
end

Then(/^(Joe|Patricia) should see company "([^"]*)"$/) do |actor, company_name|
  expect(actor.visible_company_name).to eq(company_name)
end

Then(/^(Joe|Patricia) should find company "([^"]*)"$/) do |actor, company_name|
  actor.attempts_to_search_for company_name
  expect(actor.visible_company_name).to eq(company_name)
end

module AttemptsToSubmitCompany
  def attempts_to_submit_company(name:)
    visit new_company_path
    fill_in 'Company name', with: name
    select 'United Kingdom', from: 'Company HQ'
    select 'Software', from: 'Sector'
    click_button 'Submit'
  end

  def attempts_to_submit_company_as_visitor(name:, statement_url:, your_email:)
    visit new_company_statement_companies_path
    fill_in 'Company name', with: name
    fill_in 'Statement URL', with: statement_url
    fill_in 'Your email', with: your_email
    click_button 'Submit'
  end
end

module SeesACompanyOnThePage
  def visible_company_name
    find('[data-content="company_name"]').text
  end
end

class Visitor
  include AttemptsToSubmitCompany
  include SeesACompanyOnThePage
end
