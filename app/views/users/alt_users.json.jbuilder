json.array!(@other_users) do |user|
  json.name user.first_name + ' ' + user.last_name
  json.url '/' + user.user_name
  json.image_link user_search_info(user)
end
