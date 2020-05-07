class ContentExtractionWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker

  sidekiq_options queue: :extract, retry: 0

  sidekiq_throttle({
    # Allow maximum 10 concurrent jobs of this class at a time.
    :concurrency => { :limit => 16 },
    :ttl => 20.minutes.to_i
  })

  def perform(statement_id)
    statement = Statement.includes(:snapshot).find(statement_id)
    statement.extract_content_from_statement
  end
end
