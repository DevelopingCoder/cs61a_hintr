json.extract! comment, :id, :upvotes, :downvotes, :is_final, :created_at, :updated_at
json.url comment_url(comment, format: :json)