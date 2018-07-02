When('{actor} views the public stats') do |actor| # rubocop:disable Style/SymbolProc
  actor.attempts_to_view_public_stats
end

Then('{actor} should see the following public stats:') do |actor, table|
  expect(actor.visible_public_stats.to_h).to include(table.rows_hash.to_h.symbolize_keys)
end

module ViewsPublicStats
  def attempts_to_view_public_stats
    visit root_path
  end

  def visible_public_stats
    dom_struct(:stats_counters, :uk_statements, :uk_companies, :us_statements, :us_companies)
  end
end

class Visitor
  include ViewsPublicStats
end
