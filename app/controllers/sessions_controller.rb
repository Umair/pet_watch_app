class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = 'Login successful!'
      redirect_to pets_path
    else
      flash.now[:alert] = 'Invalid email or password.'
      render :new, status: :unauthorized
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'Logged out successfully.'
    redirect_to root_path
  end
end
