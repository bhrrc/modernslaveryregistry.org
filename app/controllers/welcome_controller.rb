class WelcomeController < ApplicationController
  def index
    puts "Loading"
    @statements = Statement.includes(:company)
    puts "Done"
  end
end
