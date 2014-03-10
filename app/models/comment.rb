class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :commentable, polymorphic: true

  validates_presence_of :kasa_comment
end
