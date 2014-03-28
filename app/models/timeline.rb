class Timeline < ActiveRecord::Base
  belongs_to :user
  belongs_to :momentable, polymorphic: true

  self.per_page = 4
end
