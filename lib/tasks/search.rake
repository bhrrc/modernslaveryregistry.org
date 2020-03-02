namespace :search do
  desc 'reindex Elasticsearch indexes in a background'
  task reindex: :environment do
    Company.reindex(async: true)
  end
end
