When(/^([A-Z]\w+) searches for "([^"]*)"$/) do |actor, query|
  actor.attempts_to(Search.for(query))
end

class Search < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)

    browser.visit(root_path)
    browser.fill_in('search', with: @query)
    browser.click_button 'Search'
  end

  def self.for(query)
    instrumented(self, query)
  end

  def initialize(query)
    @query = query
  end
end
