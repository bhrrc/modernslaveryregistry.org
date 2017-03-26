class WelcomeController < ApplicationController
  def index
    @companies = Company.includes(:newest_statement).all
  end
end
