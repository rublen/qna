class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  accepts_nested_attributes_for :attachments

  validates :title, :body, presence: true

  def best_answer
    answers.find_by(best: true)
  end
end
