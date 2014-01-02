class User < ActiveRecord::Base
  has_secure_password

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

  validates :password, length: { minimum: 6 },
            if: :password_digest_changed?

  validates :password_confirmation, presence: true, if: :password_digest_changed?

  validates_exclusion_of :password, in: ->(user) { [user.login_name, user.first_name] },
                         message: 'should not be the same as your login name or first name'

end
