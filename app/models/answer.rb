class Answer < ApplicationRecord
  before_validation :default_values, on: :create

  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :body, presence: true
  validates :best, inclusion: { in: [true, false] }
  validate :question_cannot_have_more_than_one_best_answer, on: :update

  def mark_the_best
    question.best_answer&.update(best: false)
    update(best: true)
  end

  private

  def default_values
    self.best ||= false
  end

  def question_cannot_have_more_than_one_best_answer
    if best && question.answers.where(best: true).count > 0
      errors.add(:base, "Question can't have more than one best answer")
    end
  end
end
