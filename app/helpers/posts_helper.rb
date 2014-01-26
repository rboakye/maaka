module PostsHelper
  require 'securerandom'

  def create_join(post_id, user_id)
    UserPost.create(user_id: user_id, post_id: post_id)
  end

  def create_connected_join(post_id, connect_id)
    UserPost.create(user_id: connect_id, post_id: post_id)
  end

  def get_connected_name(kasa)
     first_name = User.find(kasa.connected_id).first_name
     return first_name
  end

  def get_connected_url(kasa)
    user_name = User.find(kasa.connected_id).user_name
    return "/#{user_name}"
  end
end
