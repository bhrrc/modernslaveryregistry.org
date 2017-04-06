class CurrentPage < Fellini::Question
  def answered_by(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    browser.find(@selector).text
  end

  def initialize(selector)
    @selector = selector
  end

  def self.company_name
    new('[data-content="company_name"]')
  end
end

Before do
  @actors = {}
end

Transform /^(Joe|Patricia)$/ do |actor_name|
  @actors[actor_name] ||= Fellini::Actor
    .named(actor_name)
    .who_can(Fellini::Abilities::BrowseTheWeb.new)
end
