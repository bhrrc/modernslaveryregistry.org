class ExploreController < ApplicationController
  def index
    @statements = Statement.search(current_user, params)
    respond_to do |format|
      format.html
      format.csv do
        send_data Statement.to_csv(@statements),
          filename: "modernslaveryregistry-#{Date.today}.csv"
      end
    end
  end
end
