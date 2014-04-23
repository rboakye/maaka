class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :commentable, polymorphic: true
  has_many :timelines, as: :momentable, dependent: :destroy

  validates_presence_of :kasa_comment
end
