json.array!(@users) do |user|
  json.extract! user, :id, :name, :email, :nickname, :icon, :github_id, :github_token
  json.url user_url(user, format: :json)
end
