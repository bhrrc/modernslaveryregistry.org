Given(/^company "([^"]*)" has been submitted$/) do |company_name|
  gb = Country.find_or_create_by!(code: 'GB', name: 'United Kingdom')
  Company.create!(name: company_name, country: gb)
end

When(/^(Joe|Patricia) submits company "([^"]*)"$/) do |actor, company_name|
  actor.attempts_to_submit_company(company_name)
end

Then(/^(Joe|Patricia) should see company "([^"]*)"$/) do |actor, company_name|
  expect(actor.visible_company_name).to eq(company_name)
end

module AttemptsToSubmitCompany
  def attempts_to_submit_company(company_name)
    visit new_company_path
    fill_in 'Company name', with: company_name
    select 'United Kingdom', from: 'Company HQ'
    select 'Software', from: 'Sector'
    click_button 'Submit'
  end
end

module SeesTheCurrentPage
  def visible_company_name
    find('[data-content="company_name"]').text
  end
end

class Visitor
  include AttemptsToSubmitCompany
  include SeesTheCurrentPage
end
