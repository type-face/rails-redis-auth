# frozen_string_literal: true

# User accounts
class User
  include ActiveModel::Validations
  include ActiveModel::SecurePassword
  include Redis::Objects

  @usernames = Redis::Set.new('users')

  has_secure_password

  attr_accessor :username
  attr_writer :password_digest

  # TODO: validate username length
  # TODO: validate username permitted characters
  validates :username, presence: true
  # TODO: validate password complexity
  validates :password, length: { minimum: 10 }
  validate :unique_username?

  def initialize(username:, password: nil)
    @username = username.downcase
    self.password = password
  end

  def save
    return unless valid?

    # TODO: run as transaction
    self.class.usernames << @username.downcase
    Redis::Value.new(password_redis_key).value =
      password_digest
    true
  end

  def unique_username?
    errors.add(:username, 'must be unique') if self.class.usernames.member? username
  end

  def password_digest
    @password_digest ||= Redis::Value.new(password_redis_key).value
  end

  def password_redis_key
    "password:#{@username}"
  end

  class << self
    attr_reader :usernames

    def find(username)
      return unless usernames.member? username.downcase

      new(username: username)
    end
  end
end
