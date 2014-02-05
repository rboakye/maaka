class Image < ActiveRecord::Base
  has_many :user_images
  has_many :users, through: :user_images

  # This method associates the attribute ":photo" with a file attachment
  has_attached_file :photo, styles: {
      square: '200x200#',
      medium: '600x600>'
  }

  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
end
