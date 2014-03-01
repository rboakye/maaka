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
    @access_link = url_for(controller:"access", action:"password_reset_access",access:password,ref:@user.user_uuid, only_path: false, :protocol => "https")
    mail(:to => @user.email, :subject => "Makasa Password Reset Notification")
  end

  def user_notification(user,con_user)
    @user = user
    @con_user = con_user
    @time = Time.now.to_s.humanize
    attachments['makasa_logo_title_sm.png'] = File.read(Rails.root.join('app/assets/images/makasa_logo_title_sm.png'))
    @url = "makasa.herokuapp.com"
    mail(:to => @con_user.email, :subject => "#{@user.first_name} Kasa on your timeline")
  end

  def request_connect(receiver,sender)
    @user = sender
    @con_user = receiver
    @time = Time.now.to_s.humanize
    attachments['makasa_logo_title_sm.png'] = File.read(Rails.root.join('app/assets/images/makasa_logo_title_sm.png'))
    @url = "makasa.herokuapp.com"
    mail(:to => @con_user.email, :subject => "#{@user.first_name} wants to connect with you on Makasa")
  end

  def user_activation(user)

  end
end
