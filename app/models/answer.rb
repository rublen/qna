class Answer < ApplicationRecord
  include Attachable, Votable, Commentable
  after_create :follow_question_mails

  belongs_to :question, touch: true
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

  private

  def follow_question_mails
    FollowQuestionJob.perform_later(question)
  end
end
