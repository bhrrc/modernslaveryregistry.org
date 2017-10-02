# Tries to set the URL to https if possible - even if it was entered as http.
# This is not only more secure, but it allows the site to display the statement
# inside an iframe. Most browsers will block non-https iframes on an https site.

class StatementUrl
  def initialize(url)
    @url = url
  end

  def self.fetch(url)
    new(url).fetch
  end

  def fetch
    visit_if_url_format_valid
    FetchResult.with(
      url: @url,
      broken_url: @broken_url,
      content_type: @content_type,
      content_data: @content_data
    )
  end

  private

  def visit_if_url_format_valid
    uri = try_to_parse(@url)
    if uri.nil?
      @broken_url = true
      return
    end
    visit_uri uri
  end

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
      @broken_url = true
    end
  end

  def try_to_open_with_scheme(uri, scheme)
    uri.scheme = scheme
    response = try_to_open uri
    @url = uri.to_s
    @broken_url = false
    @content_data = response.body
    @content_type = response.headers[:content_type]
  end

  def try_to_open(uri)
    RestClient::Request.execute(
      method: :get,
      url: uri.to_s,
      timeout: 25,
      headers: { 'User-Agent' => browser_user_agent, 'Accept-Encoding' => 'identity' }
    )
  rescue => e
    e.response || raise(e)
  end

  def browser_user_agent
    # Some sites don't like non-browser user agents - pretend to be Chrome
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) ' \
    'Chrome/57.0.2987.133 Safari/537.36'
  end
end
