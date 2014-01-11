class AccessController < ApplicationController
  def index
  end

  def attempt_login
    if params[:email].present? && params[:password].present?
      found_user = User.where(:email => params[:email]).first
      if found_user
        authorized_user = found_user.authenticate(params[:password])
      end
    end
    if authorized_user
      # mark user as logged in
      session[:user_id] = authorized_user.id
      @user_session = UserSession.new(session[:user_id])
      flash[:notice] = "#{authorized_user.first_name}, you are now logged in "
      redirect_to controller: 'users', action: 'index'
    else
      flash[:error] = "Invalid username/password combination."
      redirect_to controller: 'users', action: 'index'
    end
  end

  def logout
    # mark user as logged out
    session[:user_id] = nil
    session[:last_seen] = nil
    session[:username] = nil
    flash[:notice] = "Logged out successfully"
    redirect_to controller: 'users', action: 'index'
  end
end
