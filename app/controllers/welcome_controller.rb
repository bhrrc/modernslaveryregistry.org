class WelcomeController < ApplicationController
  include ApplicationHelper

  def index
    @stats = Statement.search(admin: admin?, criteria: {}).stats
  end
end
