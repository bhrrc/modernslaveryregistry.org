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

class TheCompany < Fellini::Question
  def answered_by(actor)
    WebPage.find('h1').answered_by(actor)
  end

  def self.company_name
    new
  end
end

class WebPage < Fellini::Question
  include Capybara::DSL

  def answered_by(actor)
    find(@selector).text
  end

  def self.find(selector)
    new(selector)
  end

  def initialize(selector)
    @selector = selector
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

Then(/^([A-Z]\w+) should see company "([^"]*)"$/) do |actor, company_name|
  expect(actor.to_see(TheCompany.company_name)).to eq(company_name)
end
