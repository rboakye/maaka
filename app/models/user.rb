class User < ActiveRecord::Base
  before_save { |user| user.user_name = user.user_name.downcase }
  before_save { |user| user.email = user.email.downcase }

  has_secure_password
  has_many :user_posts, dependent: :destroy
  has_many :posts, through: :user_posts
  has_one :user_session, dependent: :destroy
  has_many :user_images, dependent: :destroy
  has_many :images, through: :user_images
  has_many :user_communities, dependent: :destroy
  has_many :communities, through: :user_communities
  has_many :messages, dependent: :destroy
  has_many :timelines
  has_many :audio_pieces, dependent: :destroy

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

  validates_numericality_of :phone, :allow_blank => true, :message => "can have only numbers"

  validates_length_of :phone, :allow_blank => true, :minimum => 10

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

  validates_attachment :avatar, :size => { :in => 0..3.megabytes }


  scope :search_username, lambda{ |query| where(["user_name LIKE ?", "#{query}%"])}

  scope :search_users, lambda{ |query|
    return nil  if query.blank?

    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)

    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conds = 2
    where(
        terms.map { |term|
          "(LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ?)"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conds }.flatten
    )
  }


end
