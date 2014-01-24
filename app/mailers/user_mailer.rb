class UserMailer < ActionMailer::Base
  default from: "no-reply@makasa.herokuapp.com"

  def welcome_email(user)
     @user = user
     attachments['makasa_logo.png'] = File.read(Rails.root.join('app/assets/images/makasa_logo.png'))
     @url = "makasa.herokuapp.com"
     mail(:to => @user.email, :subject => "Welcome to Makasa #{@user.first_name}")
  end

  def password_change_email(user)
    @user = user
    @time = Time.now.to_s.humanize
    attachments['makasa_logo.png'] = File.read(Rails.root.join('app/assets/images/makasa_logo.png'))
    @url = "makasa.herokuapp.com"
    mail(:to => @user.email, :subject => "Makasa Password Change Notification")
  end

  def password_reset(user,password)
    @user = user
    @time = Time.now.to_s.humanize
    attachments['makasa_logo_title_sm.png'] = File.read(Rails.root.join('app/assets/images/makasa_logo_title_sm.png'))
    @access_link = url_for(controller:"access", action:"password_reset_access",access:password,ref:@user.user_uuid, only_path: false)
    mail(:to => @user.email, :subject => "Makasa Password Reset Notification")
  end

  def user_notification(user)

  end

  def user_activation(user)

  end
end
