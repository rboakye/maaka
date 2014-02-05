json.array!(@images) do |image|
  json.extract! image, :id, :image_description, :creator, :image_uuid
  json.url image_url(image, format: :json)
end
