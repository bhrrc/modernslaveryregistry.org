class WelcomeController < ApplicationController
  def index
    @skip_nav = true
  end
end
