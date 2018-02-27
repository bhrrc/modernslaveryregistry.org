class BulkImportJob < ApplicationJob
  queue_as :default

  def perform(company_name, statement_url)
    Statement.bulk_create!(company_name, statement_url)
  end
end
