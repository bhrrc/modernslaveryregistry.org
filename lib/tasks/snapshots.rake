namespace :snapshots do
  task fetch: :environment do
    Typhoeus::Config.user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) ' \
        'Chrome/57.0.2987.133 Safari/537.36'
    hydra = Typhoeus::Hydra.new(max_concurrency: 20)
    statements = Statement.all
    statements.each do |s|
      hydra.queue(request_for_statement(s)) unless Snapshot.where(statement_id: s.id).any?
    end
    hydra.run
  end

  def request_for_statement(s)
    puts "-> #{s.url}"
    request = Typhoeus::Request.new(s.url, followlocation: true)
    request.on_complete do |response|
      if response.success?
        fetch_result = typhoeus_fetch_result(response)
        s.build_snapshot_from_result(fetch_result)
        s.save!
      end
    end
    request
  end

  def typhoeus_fetch_result(response)
    FetchResult.with(
      url: response.request.url,
      broken_url: false,
      content_type: response.headers['Content-Type'],
      content_data: response.body
    )
  end
end
