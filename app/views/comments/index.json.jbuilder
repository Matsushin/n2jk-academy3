json.array!(@comments) do |comment|
  json.extract! comment, :id, :body, :user_id, :post_id
  json.icon comment.user.icon
end
