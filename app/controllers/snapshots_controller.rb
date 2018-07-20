class SnapshotsController < ApplicationController
  def show
    snapshot = Statement.find(params[:statement_id]).snapshot
    redirect_to url_for(snapshot.screenshot_or_original)
  end
end
