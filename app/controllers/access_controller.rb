class AccessController < ApplicationController
  require 'bcrypt'
  layout 'login'

  def index
  end

  def login_access
  end

  def request_access
  end

  def password_request
     @user = User.where(:email => params[:email]).first
     if @user
       random_password = Array.new(10).map { (65 + rand(58)).chr }.join
       @user.password = random_password
       @user.password_confirmation = random_password
       @user.save!
       UserMailer.password_reset(@user,random_password).deliver
       flash[:notice] = "Email has been sent to you to follow up with accessing Makasa"
       redirect_to root_path
     else
       flash[:error] = "We couldn't find Email '#{params[:email]}' in our records"
       redirect_to root_path
     end
  end

  def password_reset_access
     @user = User.where(:user_uuid => params[:ref]).first
     @temp_password = params[:access]
     @pass_reset = true
  end

  def attempt_login
    users = User.all
    users.each do |user|
      UserSession.create(user_id: user.id, is_online: false)
    end

    if params[:email].present? && params[:password].present?
      found_user = User.where(:email => params[:email]).first
      if found_user
        authorized_user = found_user.authenticate(params[:password])
      end
    end
    if authorized_user
      # mark user as logged in
      my_session = authorized_user.user_session
      if my_session
        my_session.is_online = true
        my_session.save!
      end
      session[:user_id] = authorized_user.id
      session[:last_seen] = Time.now
      flash[:notice] = "#{authorized_user.first_name}, you are now logged in "
      redirect_to root_path
    else
      flash[:error] = "Invalid email/password combination."
      redirect_to controller: 'access', action: 'login_access'
    end
  end

  def logout
    # mark user as logged out
    if @user_session.timed_out
       flash[:error] = "You being logged out"
    else
      flash[:notice] = "Logged out successfully"
    end
    my_session = @current_user.user_session
    if my_session
       my_session.last_seen = Time.now
       my_session.is_online = false
       my_session.save!
    end
    session[:user_id] = nil
    session[:last_seen] = nil
    session[:user_session] = nil
    if @user_session.timed_out
      redirect_to controller: 'access', action: 'login_access'
    else
      redirect_to root_path
    end
  end
end
