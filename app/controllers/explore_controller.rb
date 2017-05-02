class ExploreController < ApplicationController
  include ApplicationHelper

  def index
    @statements = Statement.search(current_user, params)
    respond_to do |format|
      format.html
      format.csv do
        send_data Statement.to_csv(@statements, admin?),
          filename: "modernslaveryregistry-#{Date.today}.csv"
      end
    end
  end
end
