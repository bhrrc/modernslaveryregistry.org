class CountriesController < ActionController::API
  def index
    @countries = Country.with_companies.all
    render json: @countries, include: [:companies]
  end
end
