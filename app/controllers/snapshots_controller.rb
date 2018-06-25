class SnapshotsController < ApplicationController
  def show
    snapshot = Statement.find(params[:statement_id]).snapshot
    send_data(
      snapshot.screenshot_or_original.download,
      type: snapshot.screenshot_or_original.content_type,
      disposition: 'inline',
      filename: "Modern Slavery Registry - Statement by #{snapshot.statement.company.name} (#{snapshot.statement.id})"
    )
  end
end
