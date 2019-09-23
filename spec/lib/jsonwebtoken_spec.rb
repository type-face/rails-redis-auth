# frozen_string_literal: true

require 'rails_helper'
require 'jsonwebtoken'

RSpec.describe JsonWebToken do
  it 'can encode a payload' do
    expect(JsonWebToken.encode(username: 'test@example.com')).to be_present
  end

  it 'can decode a payload' do
    username = 'test@example.com'
    expected_payload = [{
      'exp' => 7.days.from_now.to_i,
      'iss' => 'lendesk',
      'aud' => 'lendesk',
      'username' => username
    },
                        {
                          'alg' => 'HS256',
                          'typ' => 'JWT'
                        }]
    token = JsonWebToken.encode(username: username)
    expect(JWT.decode(token, Rails.application.credentials.secret_key_base))
      .to eq expected_payload
  end
end
