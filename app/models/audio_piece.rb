class AudioPiece < ActiveRecord::Base
  belongs_to :user

  has_attached_file :audio,
    :path => "sounds/:id/:style.:extension"
end
