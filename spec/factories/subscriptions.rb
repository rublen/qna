FactoryBot.define do
  factory :subscription do
    user
    question
  end

  factory :daily_subscription, class: Subscription do
    user
    question_id { nil }
  end
end
