# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: :create
  post '/login', to: 'users#login'
end
