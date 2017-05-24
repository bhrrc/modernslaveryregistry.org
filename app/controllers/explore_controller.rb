class ExploreController < ApplicationController
  include ApplicationHelper

  def index
    @statements = Statement.search(admin: admin?, query: params)
    respond_to do |format|
      format.html do
        render @statements.any? ? :index : :submit_new
      end
      format.csv do
        send_data Statement.to_csv(@statements, admin?),
                  filename: "modernslaveryregistry-#{Time.zone.today}.csv"
      end
    end
  end
end
