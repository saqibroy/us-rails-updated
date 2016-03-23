json.array!(@posts) do |post|
  json.extract! post, :id, :title, :body, :published, :published_at
  json.url post_url(post, format: :json)
end
