# frozen_string_literal: true

Redis.current = Rails.env.test? ? MockRedis.new : Redis.new(host: '127.0.0.1', port: 6379)
