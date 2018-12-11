class DetailedAnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :comments
  has_many :comments
  has_many :attachments
end
