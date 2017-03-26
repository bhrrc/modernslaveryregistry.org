Given(/^company "([^"]*)" has been registered$/) do |company_name|
  Company.create!(name: company_name)
end

When(/^([A-Z]\w+) registers company "([^"]*)"$/) do |actor, company_name|
  actor.attempts_to(RegisterCompany.called(company_name))
end

class RegisterCompany < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    browser.visit(new_company_path)
    browser.fill_in('Company name', with: @company_name)
    browser.fill_in('Website', with: @website)
    browser.click_button 'Register'
  end

  def self.called(company_name)
    instrumented(self, company_name)
  end

  def initialize(company_name)
    @company_name = company_name
    @website = 'https://bigcorp.com'
  end
end
