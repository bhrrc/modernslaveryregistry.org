class CountriesController < ActionController::API
  def index
    @countries = Country.with_companies.with_company_counts
    render json: @countries, methods: [:company_count]
  end
end
