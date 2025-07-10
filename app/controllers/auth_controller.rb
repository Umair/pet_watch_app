class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'jwt'

  # POST /signup
  def signup
    user = User.new(user_params)
    if user.save
      token = encode_token(user_id: user.id)
      render json: { token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /signin
  def signin
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = encode_token(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.secret_key_base)
  end
end
