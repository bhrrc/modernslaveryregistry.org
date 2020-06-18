Searchkick.timeout = 900
Searchkick.redis = ConnectionPool.new { Redis.new }
Searchkick.client_options = {
  retry_on_failure: true,
  transport_options:
    { request: { timeout: 250 } }
}
