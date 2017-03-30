Given(/^company "([^"]*)" has been submitted$/) do |company_name|
  gb = Country.find_by_code!('GB')
  Company.create!(name: company_name, country: gb)
end

When(/^([A-Z]\w+) submits company "([^"]*)"$/) do |actor, company_name|
  actor.attempts_to(SubmitCompany.called(company_name))
end

Then(/^([A-Z]\w+) should see company "([^"]*)"$/) do |actor, company_name|
  expect(actor.to_see(CurrentPage.company_name)).to eq(company_name)
end

class SubmitCompany < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    browser.visit(new_company_path)
    browser.fill_in('Company name', with: @company_name)
    browser.select(@country_name, from: 'Company HQ')
    browser.select(@sector_name, from: 'Sector')
    browser.click_button 'Submit'
  end

  def self.called(company_name)
    instrumented(self, company_name)
  end

  def initialize(company_name)
    @company_name = company_name
    @sector_name = "Software"
    @country_name = "United Kingdom"
  end
end
