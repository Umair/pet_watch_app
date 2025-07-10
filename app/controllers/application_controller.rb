class ApplicationController < ActionController::Base
  include ActionController::Helpers
  helper_method :current_user, :user_signed_in?

  require 'jwt'

  protected

  def authenticate_user!
    # Web (session) authentication
    if session[:user_id] && User.exists?(session[:user_id])
      @current_user = User.find(session[:user_id])
      return
    end

    # API (token) authentication
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base)[0]
      @current_user = User.find(decoded['user_id'])
    rescue
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    @current_user
  end

  def user_signed_in?
    current_user.present?
  end
end
