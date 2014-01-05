class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def welcome_email(user)
     @user = user
     mail(:to => @user.email, :subject => "Welcome to Makasa #{@user.first_name}")
  end

  def password_change(user)

  end

  def user_notification(user)

  end

  def user_activation(user)

  end
end
