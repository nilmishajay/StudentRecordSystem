class SessionsController < ApplicationController
  skip_before_action :require_login

  def new
  end

  def create
    identifier = params[:email].presence || params[:username]
    user = User.find_by(email: identifier) || User.find_by(username: identifier)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Login successful."
    else
      flash.now[:alert] = "Invalid username or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "You have been logged out."
  end
end
