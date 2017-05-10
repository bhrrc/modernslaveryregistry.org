class ExploreController < ApplicationController
  include ApplicationHelper

  def index
    @statements = Statement.search(current_user, params)
    respond_to do |format|
      format.html do
        if @statements.empty?
          render :submit_new
        else
          render :index
        end
      end
      format.csv do
        send_data Statement.to_csv(@statements, admin?),
          filename: "modernslaveryregistry-#{Date.today}.csv"
      end
    end
  end
end
