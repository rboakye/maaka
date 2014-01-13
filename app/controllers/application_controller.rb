class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :confirm_valid_session, :except => [:attempt_alt_login, :logout, :login_access]
  before_action :session_active, :except => [:attempt_alt_login,:login_access]

  class UserSession
    attr_accessor :user_id, :is_active
    def initialize(user_id)
      @user_id = user_id
      @is_active = false
    end
  end


  private

  def confirm_valid_session
    if session[:user_id]
      if session[:user_session] == nil
        session[:user_session] = UserSession.new(nil)
      else
        @user_session = session[:user_session]
      end
      user_info
      return true
    else
      if session[:user_session]
        flash[:error] = 'login is required to access Makasa'
        redirect_to controller: :access, action: :login_access
      end
      return false
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
      if session[:last_seen] < 240.minutes.ago
        session[:last_seen] = Time.now
        session[:timed_out] = true
        redirect_to controller: :access, action: :logout
      else
        session[:last_seen] = Time.now
      end
    else
      session[:last_seen] = Time.now
    end
  end

  def set_access_params
    @user_session = UserSession.new(session[:user_id])
    @user_session.user_id = session[:user_id]
    @user_session.is_active = true
    session[:user_session] = @user_session
    session[:timed_out] = false
  end
end
