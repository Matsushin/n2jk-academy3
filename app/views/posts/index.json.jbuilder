json.array!(@posts) do |post|
  json.extract! post, :id, :user_id, :body
  json.title post.title
  json.updated_at l post.updated_at, format: :short
  json.icon post.user.icon
end
