Given(/^company "([^"]*)" has been submitted$/) do |company_name|
  gb = Country.find_or_create_by!(code: 'GB', name: 'United Kingdom')
  Company.create!(name: company_name, country: gb)
end

When(/^(Joe|Patricia) submits company "([^"]*)"$/) do |actor, company_name|
  actor.attempts_to(SubmitCompany.called(company_name))
end

Then(/^(Joe|Patricia) should see company "([^"]*)"$/) do |actor, company_name|
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
    @sector_name = 'Software'
    @country_name = 'United Kingdom'
  end
end

class CurrentPage < Fellini::Question
  def answered_by(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    browser.find(@selector).text
  end

  def initialize(selector)
    @selector = selector
  end

  def self.company_name
    new('[data-content="company_name"]')
  end
end
