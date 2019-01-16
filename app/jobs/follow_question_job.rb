class FollowQuestionJob < ApplicationJob
  queue_as :default
  def perform(question)
    question.subscriptions.find_each do |subscription|
      QuestionMailer.fresh_answer(question, subscription.user).deliver_now
    end
  end
end
