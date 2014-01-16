class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :confirm_valid_session, :except => [:attempt_login, :login_access]
  before_action :session_active, :except => [:attempt_login,:login_access, :logout]

  class UserSession
    attr_accessor :user_id, :is_active, :timed_out
    def initialize(user_id)
      @user_id = user_id
      @is_active = false
      @timed_out = false
    end
  end


  private

  def confirm_valid_session
    url = request.original_url
    if session[:user_id]
      if session[:user_session] == nil
        @user_session = UserSession.new(session[:user_id])
        @user_session.is_active = true
        session[:user_session] = @user_session
      else
        @user_session = session[:user_session]
      end
      user_info
      @user_session.timed_out = false
      return true
    elsif url == root_url || url == users_url || url == new_user_url
      return false
    else
      flash[:error] = 'login is required to access Makasa'
      @user_logged_in = false
      redirect_to controller: :access, action: :login_access
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
        if @user_session
          @user_session.timed_out = true
        end
        redirect_to controller: :access, action: :logout
      else
        session[:last_seen] = Time.now
      end
    else
      session[:last_seen] = Time.now
    end
  end

end
