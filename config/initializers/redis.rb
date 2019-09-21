if Rails.env.test?
  Redis.current = MockRedis.new
else
  Redis.current = Redis.new(host: '127.0.0.1', port: 6379)
end