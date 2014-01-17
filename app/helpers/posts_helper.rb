module PostsHelper
  require 'securerandom'

  def create_join(post_id, user_id)
    UserPost.create(user_id: user_id, post_id: post_id)
  end

end
