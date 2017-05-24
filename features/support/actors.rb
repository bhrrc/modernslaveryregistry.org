Before do
  @actors = {}
end

Transform /^(Joe|Patricia|Vicky)$/ do |actor_name|
  @actors[actor_name] ||= Fellini::Actor
                          .named(actor_name)
                          .who_can(Fellini::Abilities::BrowseTheWeb.new)
end
