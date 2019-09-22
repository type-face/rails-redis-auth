# frozen_string_literal: true

# User accounts
class User
  include ActiveModel::Validations
  include ActiveModel::SecurePassword
  include Redis::Objects
  @@usernames = Redis::Set.new('users')

  has_secure_password
  attr_accessor :username, :password_digest
  validates :username, presence: true
  validates :password, length: { minimum: 10 }

  def initialize(username:, password:)
    @username = username.downcase
    self.password = password
  end

  def save
    @@usernames << @username.downcase
    Redis::Value.new(User.password_redis_key(@username)).value =
      password_digest
    true
  end

  class << self
    def usernames
      @@usernames
    end

    def find(username)
      return false unless usernames.member? username.downcase

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
