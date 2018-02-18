class ExploreController < ApplicationController
  include ApplicationHelper

  def index
    respond_to do |format|
      format.html do
        @download_url = explore_path(criteria_params.merge(format: 'csv'))
        @search = search
        @statements = search.statements.page params[:page]
      end
      format.csv do
        send_csv
      end
    end
  end

  private

  def search
    Statement.search(include_unpublished: admin?, criteria: criteria_params)
  end

  def send_csv
    send_data Statement.to_csv(search.statements, admin?), filename: csv_filename
  end

  def criteria_params
    {
      sectors: params[:sectors],
      countries: params[:countries],
      company_name: params[:company_name],
      legislation_names: params
        .to_unsafe_hash
        .find_all { |key, _| key =~ /^legislation_/ }
        .map { |key, _| key.gsub(/^legislation_/, '') }
    }
  end

  def csv_filename
    "modernslaveryregistry-#{Time.zone.today}.csv"
  end
end
