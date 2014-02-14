class Comment < ActiveRecord::Base
  belongs_to :post
  has_many :image_comments
  has_many :images, through: :image_comments
  validates_presence_of :kasa_comment
end
