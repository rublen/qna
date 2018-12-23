class DailyMailer < ApplicationMailer
  def digest(user)
    @greeting = "Hi from QNA! We have got new questions today: "
    @questions = Question.last_day_list
    @subscription = user.subscriptions.find_by(question: nil)
    mail to: user.email
  end
end
