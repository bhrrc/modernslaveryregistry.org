When(/^(Joe|Patricia) views the compliance stats$/) do |actor|
  actor.attempts_to(ViewStats.minimum_compliance_requirements)
end

Then(/^(Joe|Patricia) should see the following stats:$/) do |actor, table|
  expect(actor.to_see(TheVisibleStats.minimum_compliance_requirements).to_h).to eq(table.rows_hash.symbolize_keys)
end

class ViewStats < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    browser.visit(admin_dashboard_path)
  end

  def self.minimum_compliance_requirements
    instrumented(self)
  end
end

class TheVisibleStats < Fellini::Question
  include Fellini::Capybara::DomStruct

  def answered_by(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    struct(
      browser,
      :minimum_compliance_requirements_stats,
      :percent_link_on_front_page,
      :percent_signed_by_director,
      :percent_approved_by_board,
      :percent_fully_compliant
    )
  end

  def self.minimum_compliance_requirements
    new
  end
end
