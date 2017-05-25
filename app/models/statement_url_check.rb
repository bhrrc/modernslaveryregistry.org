class StatementUrlCheck
  def initialize(url)
    @url = url
    uri = try_to_parse(@url)
    if uri.nil?
      @broken = true
      return
    end
    visit_uri uri
  end

  def broken?
    @broken
  end

  attr_reader :url

  private

  def try_to_parse(url)
    URI(url)
  rescue
    nil
  end

  def visit_uri(uri)
    try_to_open_with_scheme uri, 'https'
  rescue
    begin
      try_to_open_with_scheme uri, 'http'
    rescue
      # Set the statement URL to http, even though we haven't been able to
      # establish whether or not the url should be http or https.
      # It's more likely that http works than https.
      @url = uri.to_s
      @broken = true
    end
  end

  def try_to_open_with_scheme(uri, scheme)
    uri.scheme = scheme
    try_to_open uri
    @url = uri.to_s
    @broken = false
  end

  def try_to_open(uri)
    # The :read_timeout option for open-uri's open doesn't work with https,
    # only http.
    Timeout.timeout(3) { open(uri.to_s, 'User-Agent' => browser_user_agent) }
  end

  def browser_user_agent
    # Some sites don't like non-browser user agents - pretend to be Chrome
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) ' \
    'Chrome/57.0.2987.133 Safari/537.36'
  end
end
