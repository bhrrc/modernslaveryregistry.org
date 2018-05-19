When('{actor} searches for {string}') do |actor, query|
  actor.attempts_to_search_for(query)
end

When('{actor} selects industry {string}') do |actor, industry|
  actor.attempts_to_filter_by_industry(industry)
end

When('{actor} selects legislation {string}') do |actor, legislation|
  actor.attempts_to_filter_by_legislation(legislation)
end

Then('{actor} should find no company called {string} exists') do |actor, company_name|
  actor.attempts_to_search_for(company_name)
  expect(actor.visible_statement_search_results_summary).to eq('No statements found')
end

module ExploresStatements
  def attempts_to_search_for(query)
    visit explore_path
    fill_in 'company_name', with: query
    click_button 'Search'
  end

  def attempts_to_filter_by_industry(industry)
    visit explore_path
    select industry, from: 'industries_'
    click_button 'Search'
  end

  def attempts_to_filter_by_legislation(legislation)
    visit explore_path
    legislations_to_check = legislation.split(',').map(&:strip)
    Legislation.all.map(&:name).each do |legislation_name|
      if legislations_to_check.include? legislation_name
        check legislation_name
      else
        uncheck legislation_name
      end
    end
    click_button 'Search'
  end

  def visible_statement_search_results_summary
    find('[data-content="company_search_results"] h2').text
  end
end

class Visitor
  include ExploresStatements
end
