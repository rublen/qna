class DailyMailerJob < ApplicationJob
  def perform
    return if Question.last_day_list.empty?

    User.find_each do |user|
      DailyMailer.digest(user).deliver_later if user.daily_subscribed?
    end
  end
end
