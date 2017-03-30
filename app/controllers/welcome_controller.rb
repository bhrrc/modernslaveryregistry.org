class WelcomeController < ApplicationController
  def index
    @companies = Company.search(params[:search])
  end
end
