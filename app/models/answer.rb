class Answer < ApplicationRecord
  include Attachable

  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :body, presence: true
  validates :best, inclusion: { in: [true, false] },
                   uniqueness: {
                     scope: :question_id,
                     message: "answer: question can't have more than one"
                   }, if: :best

  scope :best_first, -> { order(best: :desc) }

  def mark_the_best
    transaction do
      question.best_answer&.update!(best: false)
      update!(best: true)
    end
  end
end
