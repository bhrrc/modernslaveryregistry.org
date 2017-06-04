require_relative './fellini'

Before do
  @actors = {
    'Joe'      => Administrator.named('Joe'),
    'Patricia' => Administrator.named('Patricia'),
    'Vicky'    => Visitor.new('Vicky')
  }
end

class Actor
  include Rails.application.routes.url_helpers
  include Capybara::DSL

  def default_url_options
    Rails.application.routes.default_url_options
  end

  attr_reader :name

  def self.named(name)
    new(name)
  end

  def initialize(name)
    @name = name
  end
end

class Visitor < Actor
end

class Administrator < Visitor
end

Transform(/^(Joe|Patricia|Vicky)$/) do |actor_name|
  @actors[actor_name]
end
