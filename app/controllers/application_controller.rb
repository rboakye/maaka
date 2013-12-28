class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :confirm_valid_session, :except => [:login, :attempt_alt_login]
  before_action :session_active, :except => [:login, :attempt_alt_login]

  class UserSession
    attr_accessor :user_id
    def initialize(id)
      @user_id = id
    end
  end

  def confirm_valid_session
    if session[:user_id]
      user_info
      true
    else
      false
    end
  end

  def user_info
    @current_user = User.find(session[:user_id])
    if @current_user
      @user_fullname = @current_user.first_name + ' ' + @current_user.last_name
      @username = @current_user.login_name
      @user_email = @current_user.email
      @user_guid = @current_user.user_uuid
      @user_logged_in = true
    end
  end

  def session_active
    if session[:last_seen]
      if session[:last_seen] < 60.minutes.ago
        session[:last_seen] = Time.now
        @timed_out = true
        redirect_to controller: :access, action: :logout
      else
        session[:last_seen] = Time.now
      end
    else
      session[:last_seen] = Time.now
    end
  end
end
