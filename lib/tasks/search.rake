namespace :search do
  desc 'reindex Elasticsearch indexes in a background'
  task reindex: :environment do
    Company.reindex(async: true)
  end

  desc 'download all statements and extract their text'
  task extract_statements: :environment do
    Statement.where(content_extracted: false).find_each do |statement| 
      ContentExtractionWorker.perform_later(statement.id)
    end
  end
end
