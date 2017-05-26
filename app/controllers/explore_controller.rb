class ExploreController < ApplicationController
  include ApplicationHelper

  def index
    respond_to do |format|
      format.html do
        @search = search
      end
      format.csv do
        send_data Statement.to_csv(search.statements, admin?),
                  filename: "modernslaveryregistry-#{Time.zone.today}.csv"
      end
    end
  end

  private

  def search
    Statement.search(admin: admin?, criteria: criteria_params)
  end

  def criteria_params
    {
      sectors: params[:sectors],
      countries: params[:countries],
      company_name: params[:company_name]
    }
  end
end
