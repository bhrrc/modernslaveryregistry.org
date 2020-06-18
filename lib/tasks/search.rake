namespace :search do
  desc 'reindex Elasticsearch indexes in a background'
  task reindex: :environment do
    Rails.logger.info "Starting reindex"
    Company.reindex(async: {wait: true})
    Company.search_index.refresh
    Statement.reindex(async: {wait: true})
    Statement.search_index.refresh
    Rails.logger.info "Completed reindex"
  end

  desc 'download all statements and extract their text'
  task extract_statements: :environment do
    Statement.where(content_extracted: false).find_each do |statement| 
      ContentExtractionWorker.perform_async(statement.id)
    end
  end

  desc 'truncate statement contents'
  task truncate_statements: :environment do
    Statement.where(content_extracted: true).find_each do |statement|
      if statement.content_text.present?
        statement.update_columns(content_text: statement.content_text.truncate(32000, separator: ' '))
      end
    end
  end
end
