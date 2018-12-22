FactoryBot.define do
  factory :subscription do
    user
    question_id { create(:question).id }
  end

  factory :daily_subscription, class: Subscription do
    user
    question_id { 0 }
  end
end
