module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :verify_authenticity_token

      def signup
        user = User.new(user_params)
        if user.save
          token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
          render json: { token: token }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def signin
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
          render json: { token: token }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      private

      def user_params
        params.permit(:email, :password, :password_confirmation)
      end
    end
  end
end
