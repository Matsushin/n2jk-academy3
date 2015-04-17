json.array!(@users) do |user|
  json.extract! user, :id, :name, :email, :nickname, :icon, :github_id, :github_token
  json.post_count user.posts.count
  json.created_at l user.created_at, format: :short
end
