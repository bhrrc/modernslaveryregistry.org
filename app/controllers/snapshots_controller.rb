class SnapshotsController < ApplicationController
  def show
    snapshot = Statement.find(params[:statement_id]).snapshot
    send_data(
      snapshot.data_for_display,
      type: snapshot.content_type_for_display,
      disposition: 'inline',
      filename: "Modern Slavery Registry - Statement by #{snapshot.statement.company.name} (#{snapshot.statement.id})"
    )
  end
end
