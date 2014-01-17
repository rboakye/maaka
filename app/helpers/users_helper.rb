module UsersHelper
  require 'securerandom'

  def generate_user_name(user)
    # create username from first and last name
    first = user.first_name[0,1].downcase
    middle = user.last_name.downcase

    match_users = User.all
    last = rand(1..100).to_s
    username = first + middle + last
    return username
  end

  def user_image(user,size)
    if user.avatar_file_name?
      link = image_tag user.avatar.url(size), class: "avatar img-rounded", alt: "#{user.first_name}"
    else
      link = image_tag "mystery_man.jpg", class: "avatar img-thumbnail", alt: "avatar"
    end
    return link
  end

  def username_by_guid(guid)
    user = User.where(:user_uuid => guid).first
    name = user.first_name + ' ' + user.last_name
    return name
  end

  def user_by_guid(guid)
     user = User.where(:user_uuid => guid).first
     return user
  end

  end
