class ExploreController < ApplicationController
  def index
    @companies = Company.search(params)
  end
end
