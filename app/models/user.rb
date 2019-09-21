# frozen_string_literal: true

# User accounts
class User
  include ActiveModel::Validations
  include Redis::Objects
  @@usernames = Redis::Set.new('users')

  attr_accessor :username, :password
  validates :username, :password, presence: true

  def initialize(username:, password:)
    @username = username
    @password = password
  end

  def save
    @@usernames << @username
    Redis::Value.new(User.password_redis_key(@username)).value = @password
    true
  end

  class << self
    def usernames
      @@usernames
    end

    def find(username)
      return false unless usernames.member? username

      password = password_lookup(username)
      new(username: username, password: password)
    end

    def password_lookup(username)
      Redis::Value.new(password_redis_key(username)).value
    end

    def password_redis_key(username)
      "password:#{username}"
    end
  end
end
