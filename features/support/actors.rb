require_relative './dom_struct'

# Implementation of the Screenplay pattern, inspired by:
#
# * https://www.infoq.com/articles/Beyond-Page-Objects-Test-Automation-Serenity-Screenplay
# * http://serenity-js.org/
# * https://github.com/serenity-bdd/serenity-core/tree/master/serenity-screenplay

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
  include DomStruct

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

  def email
    "#{name}@test.com"
  end
end

class Visitor < Actor
  def admin?
    false
  end
end

class Administrator < Visitor
  def admin?
    true
  end
end

Transform(/^(Joe|Patricia|Vicky)$/) do |actor_name|
  @actors[actor_name]
end
