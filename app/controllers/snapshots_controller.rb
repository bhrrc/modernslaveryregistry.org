class SnapshotsController < ApplicationController
  def show
    @statement = Statement.find(params[:statement_id])
    send_data @statement.content_data, type: @statement.content_type, disposition: 'inline'
  end
end
