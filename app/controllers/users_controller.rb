# frozen_string_literal: true

require 'jsonwebtoken'

class UsersController < ApplicationController
  def create
    user = User.new(username: permitted_attributes[:username],
                    password: permitted_attributes[:password])
    if user.valid? && user.save
      render json: { user: { username: user.username } }, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find(permitted_attributes[:username].downcase)
    if user.authenticate(permitted_attributes[:password])
      auth_token = JsonWebToken.encode(username: user.username)
      render json: { auth_token: auth_token }, status: :ok
    else
      render json: { error: 'Invalid username / password' },
             status: :unauthorized
    end
  end

  private

  def permitted_attributes
    params.permit(:username, :password)
  end
end
