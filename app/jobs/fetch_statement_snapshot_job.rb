class FetchStatementSnapshotJob < ApplicationJob
  queue_as :default

  def perform(statement_id)
    statement = Statement.find(statement_id)
    statement.fetch_snapshot
    statement.save!
    ContentExtractionWorker.perform_async(statement_id)
  end
end
