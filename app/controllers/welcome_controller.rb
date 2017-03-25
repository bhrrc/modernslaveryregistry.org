class WelcomeController < ApplicationController
  def index
    @statements = Statement.includes(:company)
  end
end
