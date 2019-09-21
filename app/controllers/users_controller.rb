class UsersController < ApplicationController
  def create
    user = User.new(username: permitted_attributes[:username], password: permitted_attributes[:password])
    if user.valid? && user.save
      render json: { user: { username: user.username } }, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def permitted_attributes
    params.require(:user).permit(:username, :password)
  end
end
