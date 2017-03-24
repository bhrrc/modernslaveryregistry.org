# Implementation of the Screenplay pattern, inspired by:
#
# * https://www.infoq.com/articles/Beyond-Page-Objects-Test-Automation-Serenity-Screenplay
# * http://serenity-js.org/
# * https://github.com/serenity-bdd/serenity-core/tree/master/serenity-screenplay
#
module Fellini
  class Actor
    def self.named(name)
      new(name)
    end

    def initialize(name)
      @name = name
      @abilities = {}
    end

    def can(do_something)
      @abilities[do_something.class] = do_something
      self
    end

    def attempts_to(*performables)
      performables.each do |performable|
        performable.perform_as(self)
      end
    end

    def to_see(question)
      question.answered_by(self)
    end

    def to_s
      "#<#{self.class}:#{@name}>"
    end
  end

  class Ability
  end

  class Performable
    def perform_as(actor)
      raise "Implement #perform_as in #{self.class}"
    end

    # Reflection so we can issue event protocol events later
    def self.instrumented(klass, *arguments)
      klass.new(*arguments)
    end
  end

  class Task < Performable
  end

  class Interaction < Performable
  end

  class Question
    def answered_by(actor)
      raise "Implement #answered_by in #{self.class}"
    end
  end
end
