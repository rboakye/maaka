class Post < ActiveRecord::Base
   has_many :user_posts
   has_many :users, through: :user_posts
   has_many :comments, dependent: :destroy

   validates_presence_of :post_content

end
