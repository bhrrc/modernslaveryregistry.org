When(/^(Joe|Patricia) views the compliance stats$/) do |actor|
  actor.attempts_to_view_minimum_compliance_requirements_stats
end

Then(/^(Joe|Patricia) should see the following stats:$/) do |actor, table|
  expect(actor.visible_minimum_compliance_requirements_stats.to_h).to eq(table.rows_hash.symbolize_keys)
end

module AttemptsToViewStats
  def attempts_to_view_minimum_compliance_requirements_stats
    visit(admin_dashboard_path)
  end
end

module SeesStats
  def visible_minimum_compliance_requirements_stats
    dom_struct(
      :minimum_compliance_requirements_stats,
      :percent_link_on_front_page,
      :percent_signed_by_director,
      :percent_approved_by_board,
      :percent_fully_compliant
    )
  end
end

class Administrator
  include AttemptsToViewStats
  include SeesStats
end
