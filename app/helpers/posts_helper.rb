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

  def find_momentable(id, type)
    if type == 'Post'
      item = Post.find(id)
      if item
        return item
      end
    elsif type == 'Image'
      item = Image.find(id)
      if item
        return item
      end
    elsif type == 'Comment'
      item = Comment.find(id)
      if item
        return item
      end
    else
      return nil
    end
  end

end
