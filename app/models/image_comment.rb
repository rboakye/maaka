class ImageComment < ActiveRecord::Base
  belongs_to :image
  belongs_to :comment
end
