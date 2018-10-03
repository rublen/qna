class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :title, :body, presence: true

  scope :best_is_first_answers_list, ->(question) { question.answers.order(best: :desc)}

  def best_answer
    answers.find_by(best: true)
  end
end
