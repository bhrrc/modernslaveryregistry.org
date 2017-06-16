class FetchStatementSnapshotJob < ApplicationJob
  queue_as :default

  def perform(statement_id)
    Statment.find(statement_id).fetch_statement_from_url!
  end
end
