class FollowQuestionJob < ApplicationJob
  queue_as :default
  def perform(question)
    Subscription.where(question_id: question.id).find_each do |subscription|
      QuestionMailer.fresh_answer(question, subscription.user).deliver_now
    end
  end
end
