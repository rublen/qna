class DailyMailer < ApplicationMailer
  def digest(user)
    @greeting = "Hi from QNA! We've got new questions today: "
    @questions = Question.last_day_list
    mail to: user.email
  end
end
