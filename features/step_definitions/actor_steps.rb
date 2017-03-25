class RegisterCompany < Fellini::Task
  def perform_as(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    browser.visit("/companies/new")
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

class CurrentPage < Fellini::Question
  def answered_by(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    browser.find('h1').text
  end

  def self.header
    new
  end
end

Before do
  @actors = {}
end

Transform /^([A-Z]\w+)$/ do |actor_name|
  @actors[actor_name] ||= Fellini::Actor
    .named(actor_name)
    .who_can(Fellini::Abilities::BrowseTheWeb.new)
end

Given(/^([A-Z]\w+) has permission to register companies$/) do |actor|
  # Not sure how to implement this rule yet
end

When(/^([A-Z]\w+) registers company "([^"]*)"$/) do |actor, company_name|
  actor.attempts_to(RegisterCompany.called(company_name))
end

Then(/^([A-Z]\w+) should see company "([^"]*)"$/) do |actor, company_name|
  expect(actor.to_see(CurrentPage.header)).to eq(company_name)
end
