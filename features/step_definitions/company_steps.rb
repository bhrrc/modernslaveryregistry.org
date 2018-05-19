Given('the company {string} has been submitted') do |company_name|
  Company.create!(
    name: company_name,
    country: Country.find_or_create_by!(code: 'GB', name: 'United Kingdom')
  )
end

When('{actor} submits the company {string}') do |actor, company_name|
  actor.attempts_to_create_company(name: company_name)
end

When('{actor} submits the following company:') do |actor, table|
  details = table.rows_hash

  if details['Your email']
    actor.attempts_to_submit_company_with_statement(
      name: details.fetch('Company name'),
      statement_url: details.fetch('Statement URL'),
      your_email: details.fetch('Your email')
    )
  else
    actor.attempts_to_submit_company_with_statement(
      name: details.fetch('Company name'),
      country: details.fetch('Company HQ'),
      industry: details.fetch('Industry'),
      statement_url: details.fetch('Statement URL'),
      period_covered: details.fetch('Period Covered')
    )
  end
end

When('{actor} submits the following company as a visitor:') do |actor, table|
  details = table.rows_hash
  actor.attempts_to_submit_company_with_statement_as_visitor(
    name: details.fetch('Company name'),
    country: details.fetch('Company HQ'),
    industry: details.fetch('Industry'),
    statement_url: details.fetch('Statement URL')
  )
end

When('{actor} deletes the company {string}') do |actor, company_name|
  actor.attempts_to_delete_company(company_name: company_name)
end

Then('{actor} should see company {string}') do |actor, company_name|
  expect(actor.visible_company_name).to eq(company_name)
end

Then('{actor} should find company {string}') do |actor, company_name|
  actor.attempts_to_search_for company_name
  expect(actor.visible_company_name).to eq(company_name)
end

Then('{actor} should find company {string} with:') do |actor, company_name, table|
  actor.attempts_to_search_for company_name
  expect(actor.visible_company_name).to eq(company_name)
  details = table.rows_hash
  expect(actor.visible_company.country).to eq(details['Company HQ'])
  expect(actor.visible_company.industry).to eq(details['Industry'])
end

module AttemptsToCreateCompany
  def attempts_to_create_company(name:)
    visit new_admin_company_path
    fill_in 'Company name', with: name
    select 'United Kingdom', from: 'Country'
    select 'Software', from: 'Industry'
    fill_in 'Subsidiary names', with: "#{name} Labs, #{name} Express"
    click_button 'Create Company'
  end

  def attempts_to_submit_company_with_statement(name:, country:, industry:, statement_url:, period_covered:)
    visit new_admin_company_path
    fill_in 'Company name', with: name
    select country, from: 'Country'
    select industry, from: 'Industry'
    fill_in 'Statement URL', with: statement_url
    enter_period_covered(period_covered)
    click_button 'Create Company'
  end

  def attempts_to_submit_company_with_statement_as_visitor(name:, country:, industry:, statement_url:)
    visit new_company_path
    fill_in 'Company name', with: name
    select country, from: 'Company HQ'
    select industry, from: 'Industry'
    fill_in 'Statement URL', with: statement_url
    click_button 'Submit'
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
  def visible_company
    dom_struct(:company, :country, :industry)
  end

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
