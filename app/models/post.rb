class Post < ActiveRecord::Base
   has_many :user_posts
   has_many :users, through: :user_posts

   has_many :comments, as: :commentable, dependent: :destroy
   has_many :timelines, as: :momentable, dependent: :destroy

   validates_presence_of :post_content

end
