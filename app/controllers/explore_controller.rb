class ExploreController < ApplicationController
  include ApplicationHelper

  def index
    @search = Statement.search(admin: admin?, criteria: criteria_params)
    respond_to do |format|
      format.html
      format.csv do
        send_data Statement.to_csv(@search, admin?),
                  filename: "modernslaveryregistry-#{Time.zone.today}.csv"
      end
    end
  end

  private

  def criteria_params
    {
      sectors: params[:sectors],
      countries: params[:countries],
      company_name: params[:company_name]
    }
  end
end
