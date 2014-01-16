module UsersHelper
  require 'securerandom'

  def generate_user_name(user)
    # create username from first and last name
    first = user.first_name[0,1].downcase
    middle = user.last_name.downcase
    last = rand(1..100).to_s
    username = first + middle + last
    return username
  end

end
