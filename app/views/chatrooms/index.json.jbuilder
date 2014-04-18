json.array!(@chatrooms) do |chatroom|
  json.extract! chatroom, :id
  json.url chatroom_url(chatroom, format: :json)
end