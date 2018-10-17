FactoryBot.define do
  sequence :title do |n|
    "QuestionTitle#{n}"
  end

  factory :question do
    title
    body { "MyText" }
    association :author, factory: :user
  end

  factory :invalid_question, class: Question do
    title { nil }
    body { nil }
    user_id { nil }
  end
end
