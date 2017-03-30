class WelcomeController < ApplicationController
  def index
    @companies = Company.includes(:newest_statement, :country, :sector).all #.last(10)
  end
end
