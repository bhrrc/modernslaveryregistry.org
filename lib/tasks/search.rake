namespace :search do
  desc 'reindex Elasticsearch indexes in a background'
  task reindex: :environment do
    Company.reindex
  end

  desc 'download all statements and extract their text'
  task extract_statements: :environment do
    Statement.where(content_extracted: false).find_each do |statement| 
      ContentExtractionWorker.perform_async(statement.id)
    end
  end
end
