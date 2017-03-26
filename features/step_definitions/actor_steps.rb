class CurrentPage < Fellini::Question
  def answered_by(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    browser.find('h1').text
  end

  def self.header
    new
  end
end

Before do
  @actors = {}
end

Transform /^([A-Z]\w+)$/ do |actor_name|
  @actors[actor_name] ||= Fellini::Actor
    .named(actor_name)
    .who_can(Fellini::Abilities::BrowseTheWeb.new)
end

Given(/^([A-Z]\w+) has permission to register companies$/) do |actor|
  # Not sure how to implement this rule yet
end

Then(/^([A-Z]\w+) should see company "([^"]*)"$/) do |actor, company_name|
  expect(actor.to_see(CurrentPage.header)).to eq(company_name)
end
