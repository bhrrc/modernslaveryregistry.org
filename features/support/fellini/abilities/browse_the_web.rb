module Fellini
  module Abilities
    class BrowseTheWeb
      include Capybara::DSL

      def self.as(actor)
        actor.ability_to(self)
      end
    end
  end
end
