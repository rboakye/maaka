class User < ActiveRecord::Base
  before_save { |user| user.user_name = user.user_name.downcase }
  has_secure_password
  has_many :user_posts, dependent: :destroy
  has_many :posts, through: :user_posts

  EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i
  validates :first_name, :presence => true,
            :length => { :maximum => 25 }
  validates :last_name, :presence => true,
            :length => { :maximum => 50 }
  validates :email, :presence => true,
            :uniqueness => true,
            :length => { :maximum => 100 },
            :format => EMAIL_REGEX,
            :confirmation => true

  validates_format_of :email, without: /NOSPAM/

  validates_uniqueness_of :user_name, :message => "has already been taken"

  validates :password, length: { minimum: 6 },
            if: :password_digest_changed?

  validates :password_confirmation, presence: true, if: :password_digest_changed?

#  validates_exclusion_of :password, in: ->(user) { [user.login_name, user.first_name] },
#                         message: 'should not be the same as your login name or first name'


  # This method associates the attribute ":avatar" with a file attachment
  has_attached_file :avatar, styles: {
      thumb: '100x100>',
      square: '200x200#',
      medium: '300x300>'
  }

  validates_attachment :avatar, :size => { :in => 0..10.megabytes }


  scope :search_username, lambda{ |query| where("user_name like ?", "#{query}%")}

end
