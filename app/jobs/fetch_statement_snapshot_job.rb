class FetchStatementSnapshotJob < ApplicationJob
  queue_as :default

  def perform(statement_id)
    statement = Statement.find(statement_id)
    statement.fetch_snapshot
  end
end
