class RegisterCompanies < Fellini::Ability
  def self.without_approval
    new(true)
  end

  def initialize(can_publish)
    @can_publish = can_publish
  end
end

class RegisterCompany < Fellini::Task
  include Capybara::DSL

  def perform_as(actor)
    puts "#{actor} registers company #{@company_name}"
    visit '/companies/new'
  end

  def self.called(company_name)
    instrumented(self, company_name)
  end

  def initialize(company_name)
    @company_name = company_name
  end
end

Before do
  @actors = {}
end

Transform /^([A-Z]\w+)$/ do |actor_name|
  @actors[actor_name] ||= Fellini::Actor.named(actor_name)
end

Given(/^([A-Z]\w+) has permission to register companies$/) do |actor|
  actor.can(RegisterCompanies.without_approval)
end

When(/^([A-Z]\w+) registers company "([^"]*)"$/) do |actor, company_name|
  actor.attempts_to(RegisterCompany.called(company_name))
end
