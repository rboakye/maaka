module UsersHelper
  require 'securerandom'

  def generate_user_name(user)
    # create username from first and last name
    first = user.first_name[0,1].downcase
    middle = user.last_name.downcase
    same_name_users = User.search_username(first+middle)
    if same_name_users.size > 0
      last = same_name_users.size + 1
      username = first + middle + last.to_s
    else
      username = first + middle
    end
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

  def friend_image(user,size)
    if user.avatar_file_name?
      link = image_tag user.avatar.url(size), class: "friends-box-img", alt: "#{user.first_name}"
    else
      link = image_tag "mystery_man.jpg", class: "friends-box-img", alt: "avatar"
    end
    return link
  end

  def user_image_comment(user,size)
    if user.avatar_file_name?
      link = image_tag user.avatar.url(size), class: "avatar img-rounded", style: "max-height: 52px; max-width: 40px", alt: "#{user.first_name}"
    else
      link = image_tag "mystery_man.jpg", class: "avatar img-thumbnail", style: "max-height: 52px; max-width: 40px", alt: "avatar"
    end
    return link
  end

  def recent_post_image(user,size)
    if user.avatar_file_name?
      link = image_tag user.avatar.url(size), class: "user_info-image img-responsive", alt: "#{user.first_name}"
    else
      link = image_tag "mystery_man.jpg", class: "user_info-image img-responsive", alt: "avatar"
    end
    return link
  end

  def username_by_guid(guid)
    user = User.where(:user_uuid => guid).first
    name = user.first_name + ' ' + user.last_name
    return name
  end

  def username_id_by_guid(guid)
    user = User.where(:user_uuid => guid).first
    user_name = user.user_name
    return user_name
  end

  def user_by_guid(guid)
     user = User.where(:user_uuid => guid).first
     return user
  end

  def in_my_community(owner, user)
     users = owner.communities
     users.each do |u|
       if u.member_uuid == user.user_uuid
         return true
       end
     end
     return false
  end

  def gen_transaction_id
    val = SecureRandom.hex
    return val
  end

  def recent_post(guid)
    user = User.where(:user_uuid => guid).first
    content_2 = ""
    posts = user.posts.limit(2)
    content_1 = "<div class='row'><div class='col-sm-12 hidden-xs hidden-sm col-md-6'>#{recent_post_image(user,'medium')}</div><div class='col-sm-12 col-xs-12 col-md-6'><p class='text-center'>Recent Kasa's</p><ul class='list-group'>"
    posts.each do |kasa|
      content_2 += "<li class='list-group-item'>#{kasa.post_content} <small class='text-info'> <i class='fa fa-clock-o'></i> #{time_ago_in_words(kasa.created_at)} ago</small></li>"
    end
    content_3 = "</ul></div></div>"
    return content_1 + content_2 + content_3
  end


  def request_sent(current_user)
     message = Message.where(sender_uuid: current_user.user_uuid, message_type: :connect).first
     if message
       return message
     else
       return false
     end
  end

  def request_receive(user)
    message = Message.where(user_id: user.id, message_type: :connect).first
    if message
      return message
    else
      return false
    end
  end

  def user_gender(id)
    user = User.find(id)
    if user
      if user.gender == 'Male'
        return 'his'
      end
      if user.gender == 'Female'
        return 'her'
      end
    end
    return 'own'
  end

end
