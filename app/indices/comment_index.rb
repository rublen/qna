ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes body
  indexes author.email, as: :author, sortable: true

  has user_id, created_at, commentable_type, commentable_id
end
