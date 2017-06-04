Given(/^(Joe|Patricia) is logged in$/) do |actor|
  login_as(find_or_create_user(name: actor.name, admin: true))
end

Given(/^(Vicky) is logged in$/) do |actor|
  login_as(find_or_create_user(name: actor.name, admin: false))
end

When(/^(Joe|Patricia|Vicky) logs in$/) do |actor|
  find_or_create_user(name: actor.name, admin: actor.name != 'Vicky')
  actor.attempts_to(LogIn)
end

When(/^(Joe|Patricia|Vicky) visits the administrator dashboard$/) do |actor|
  actor.attempts_to(VisitAdminDashboard)
end

Then(/^(Joe|Patricia|Vicky) should see the administrator dashboard$/) do |actor|
  expect(actor.to_see(VisibleArea)).to eq('Admin Dashboard')
end

Then(/^(Joe|Patricia|Vicky) should not see the administrator dashboard$/) do |actor|
  expect(actor.to_see(VisibleArea)).not_to eq('Admin Dashboard')
end

Then(/^(Joe|Patricia|Vicky) should see the home page/) do |actor|
  expect(actor.to_see(VisibleArea)).to eq('Modern Slavery Registry')
end

class LogIn < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    browser.visit new_user_session_path
    browser.fill_in 'Email', with: "#{actor.name}@test.com"
    browser.fill_in 'Password', with: 's3cr3t'
    browser.click_on 'Log in'
  end

  def self.perform_as(actor)
    new.perform_as(actor)
  end
end

class VisitAdminDashboard < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    begin
      browser.visit admin_dashboard_path
      true
    rescue ActionController::RoutingError
      false
    end
  end

  def self.perform_as(actor)
    new.perform_as(actor)
  end
end

class VisibleArea < Fellini::Question
  def answered_by(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    browser.title && browser.title.strip.gsub(/\s+\|\s+Modern Slavery Registry/, '')
  end

  def self.answered_by(actor)
    new.answered_by(actor)
  end
end
