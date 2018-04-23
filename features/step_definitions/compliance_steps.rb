When('{actor} views the compliance stats') do |actor| # rubocop:disable Style/SymbolProc
  actor.attempts_to_view_minimum_compliance_requirements_stats
end

Then('{actor} should see the following stats:') do |actor, table|
  expect(actor.visible_minimum_compliance_requirements_stats.to_h).to eq(table.rows_hash.symbolize_keys)
end

module ViewsMinimumComplianceStats
  def attempts_to_view_minimum_compliance_requirements_stats
    visit(admin_dashboard_path)
  end

  def visible_minimum_compliance_requirements_stats
    dom_struct(
      :minimum_compliance_requirements_stats,
      :'Percent link on front page',
      :'Percent signed by director',
      :'Percent approved by board',
      :'Percent fully compliant'
    )
  end
end

class Administrator
  include ViewsMinimumComplianceStats
end
