
require 'rails_helper'

RSpec.describe 'Users', type: :request do
  it 'returns success if user created' do
    post '/users', params: { user: { username: 'test@example.com', password: 'abc123!@#' } }
    expect(response.status).to eq 201
  end

  it 'returns user username if user created' do
    username = 'test@example.com'
    post '/users', params: { user: { username: 'test@example.com', password: 'abc123!@#' } }
    expect(JSON.parse(response.body)['user']['username']).to eq username
  end

  it 'returns 422 if user not created' do
    post '/users', params: { user: { username: 'test@example.com' } }
    expect(response.status).to eq 422
  end

  it 'returns error message if user not valid' do
    post '/users', params: { user: { username: 'test@example.com' } }
    expect(JSON.parse(response.body)['errors']['password']).to be_present
  end
end