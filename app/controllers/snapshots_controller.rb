class SnapshotsController < ApplicationController
  def show
    snapshot = Statement.find(params[:statement_id]).snapshot
    send_data(
      snapshot.image_content_data || snapshot.content_data,
      type: snapshot.image_content_type || snapshot.content_type,
      disposition: 'inline'
    )
  end
end
