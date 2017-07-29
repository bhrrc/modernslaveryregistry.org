Given(/^(Joe|Patricia|Vicky) is logged in$/) do |actor|
  login_as(find_or_create_user(actor))
end

When(/^(Joe|Patricia|Vicky) logs in$/) do |actor|
  find_or_create_user(actor)
  actor.attempts_to_log_in
end

When(/^(Joe|Patricia|Vicky) visits the administrator dashboard$/) do |actor| # rubocop:disable Style/SymbolProc
  actor.attempts_to_visit_admin_dashboard
end

Then(/^(Joe|Patricia|Vicky) should see the administrator dashboard$/) do |actor|
  expect(actor.visible_location_title).to eq('Admin Dashboard')
end

Then(/^(Joe|Patricia|Vicky) should not see the administrator dashboard$/) do |actor|
  expect(actor.visible_location_title).not_to eq('Admin Dashboard')
end

Then(/^(Joe|Patricia|Vicky) should see the home page/) do |actor|
  expect(actor.visible_location_title).to eq('Modern Slavery Registry')
end

module AttemptsToLogIn
  def attempts_to_log_in
    visit new_user_session_path
    fill_in 'Email', with: email
    fill_in 'Password', with: 's3cr3t'
    click_on 'Log in'
  end
end

module AttemptsToVisitAdminDashboard
  def attempts_to_visit_admin_dashboard
    visit admin_dashboard_path
    true
  rescue ActionController::RoutingError
    false
  end
end

module SeesLocationTitle
  def visible_location_title
    title && title.strip.gsub(/\s+\|\s+Modern Slavery Registry/, '')
  end
end

class Visitor
  include AttemptsToLogIn
  include AttemptsToVisitAdminDashboard
  include SeesLocationTitle
end
