class ContentExtractionWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0

  def perform(statement_id)
    statement = Statement.includes(snapshot).find(statement_id)
    statement.extract_content_from_statement
  end
end
