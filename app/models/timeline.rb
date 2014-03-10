class Timeline < ActiveRecord::Base
  belongs_to :user
  belongs_to :momentable, polymorphic: true
end
