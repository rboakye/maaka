json.array!(@comments) do |comment|
  json.extract! comment, :id, :kasa_comment
  json.url comment_url(comment, format: :json)
end
