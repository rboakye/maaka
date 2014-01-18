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
    mail(:to => @user.email, :subject => "Makasa Password Notification")
  end

  def user_notification(user)

  end

  def user_activation(user)

  end
end
