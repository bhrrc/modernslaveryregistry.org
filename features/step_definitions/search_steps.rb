When(/^(Joe|Patricia) searches for "([^"]*)"$/) do |actor, query|
  actor.attempts_to_search_for(query)
end

When(/^(Joe|Patricia) selects sector "([^"]*)"$/) do |actor, sector|
  actor.attempts_to_filter_by_sector(sector)
end

module ExploresStatements
  def attempts_to_search_for(query)
    visit explore_path
    fill_in 'company_name', with: query
    click_button 'Search'
  end

  def attempts_to_filter_by_sector(sector)
    visit explore_path
    select sector, from: 'sectors_'
    click_button 'Search'
  end
end

class Visitor
  include ExploresStatements
end
