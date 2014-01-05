json.array!(@posts) do |post|
  json.extract! post, :id, :post_by, :post_content, :is_private, :post_uuid
  json.url post_url(post, format: :json)
end
