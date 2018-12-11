class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :comments

  def comments
    object.comments.count
  end
end
