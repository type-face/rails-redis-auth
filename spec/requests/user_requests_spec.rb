# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:valid_params) do
    { username: 'test@example.com', password: 'Password123!@#' }
  end

  describe 'create' do
    it 'returns success if user created' do
      post '/users', params: valid_params
      expect(response.status).to eq 201
    end

    it 'returns username if user created' do
      post '/users', params: valid_params
      expect(JSON.parse(response.body)['user']['username'])
        .to eq valid_params[:username]
    end

    it 'returns 422 if username already exists' do
      post '/users', params: valid_params
      post '/users', params: valid_params
      expect(response.status).to eq 422
    end

    it 'returns 422 if user not created' do
      post '/users', params: { username: 'test@example.com' }
      expect(response.status).to eq 422
    end

    it 'returns error message if user not valid' do
      post '/users', params: { username: 'test@example.com' }
      expect(JSON.parse(response.body)['errors']['password']).to be_present
    end
  end

  describe 'login' do
    let(:invalid_params) do
      { username: 'test@example.com', password: 'incorrect' }
    end

    it 'returns auth token if creds are valid' do
      post '/users', params: valid_params
      post '/login', params: valid_params
      expect(response.body['auth_token']).to be_present
    end

    it 'returns 200 if creds are valid' do
      post '/users', params: valid_params
      post '/login', params: valid_params
      expect(response.status).to eq 200
    end

    it 'returns 401 if invalid creds sent' do
      post '/users', params: valid_params
      post '/login', params: invalid_params
      expect(response.status).to eq 401
    end

    it 'returns 401 if invalid creds sent' do
      post '/users', params: valid_params
      post '/login', params: invalid_params
      expect(JSON.parse(response.body)['error'])
        .to eq 'Invalid username / password'
    end
  end
end
