class QuestionMailer < ApplicationMailer
  def fresh_answer(question, user)
    @greeting = "Hi! The question __#{question.title}__ has recently been answered. Visit question page: "

    @question = question
    @subscription = user.subscriptions.where(question_id: @question.id).first

    mail to: user.email
  end
end
