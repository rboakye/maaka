json.array!(@my_users) do |user|
  json.name full_name_link(user)
end
