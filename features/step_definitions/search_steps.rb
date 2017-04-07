When(/^(Joe|Patricia) searches for "([^"]*)"$/) do |actor, query|
  actor.attempts_to(Search.for(query))
end

When(/^(Joe|Patricia) selects sector "([^"]*)"$/) do |actor, sector|
  actor.attempts_to(Filter.by_sector(sector))
end

class Search < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)

    browser.visit(explore_path)
    browser.fill_in('company_name', with: @query)
    browser.click_button 'Search'
  end

  def self.for(query)
    instrumented(self, query)
  end

  def initialize(query)
    @query = query
  end
end

class Filter < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)

    browser.visit(explore_path)
    browser.select(@value, from: @select_field)
    browser.click_button 'Search'
  end

  def self.by_sector(sector)
    instrumented(self, 'sectors_', sector)
  end

  def initialize(select_field, value)
    @select_field, @value = select_field, value
  end
end
