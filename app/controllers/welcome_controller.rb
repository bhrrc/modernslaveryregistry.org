class WelcomeController < ApplicationController
  def index
    @companies = Company.includes(:newest_statement).all #.last(10)
  end
end
