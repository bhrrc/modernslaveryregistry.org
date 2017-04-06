class WelcomeController < ApplicationController
  def index
    @companies = Company.search(params)
  end
end
