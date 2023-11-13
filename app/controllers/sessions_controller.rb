class SessionsController < ApplicationController
  
  def new

  end

  def create 
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:success] = "Logged in successfully"
      redirect_to reservations_path
    else
      flash.now[:warning] = "There was something wrong with your login details"
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    flash[:info] = "Logged out"
    redirect_to root_path
  end

end