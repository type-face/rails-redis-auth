# frozen_string_literal: true

require 'jwt'

class JsonWebToken
  def self.encode(payload)
    payload.reverse_merge!(meta)
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  # Default options to be encoded in the token
  def self.meta
    {
      exp: 7.days.from_now.to_i,
      iss: 'lendesk',
      aud: 'lendesk'
    }
  end
end
