class RegisterCompany < Fellini::Task
  def perform_as(actor)
    actor.attempts_to(SubmitRegisterCompanyForm.new(@company_name, @website))
  end

  def self.called(company_name)
    instrumented(self, company_name)
  end

  def initialize(company_name)
    @company_name = company_name
    @website = 'https://bigcorp.com'
  end
end

class SubmitRegisterCompanyForm < Fellini::Interaction
  include Capybara::DSL

  def perform_as(actor)
    visit '/companies/new'
    fill_in 'Company name', with: @company_name
    fill_in 'Website', with: @website

    click_button 'Register'
  end

  def initialize(company_name, website)
    @company_name = company_name
    @website = website
  end
end

Before do
  @actors = {}
end

Transform /^([A-Z]\w+)$/ do |actor_name|
  @actors[actor_name] ||= Fellini::Actor.named(actor_name)
end

Given(/^([A-Z]\w+) has permission to register companies$/) do |actor|
  # Not sure how to set up that ability yet
end

When(/^([A-Z]\w+) registers company "([^"]*)"$/) do |actor, company_name|
  actor.attempts_to(RegisterCompany.called(company_name))
end

Then(/^the company "([^"]*)" should be published$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end
