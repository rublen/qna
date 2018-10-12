FactoryBot.define do
  sequence :body do |n|
    "AnswerBody#{n}"
  end

  factory :answer do
    body
    question
    association :author, factory: :user
  end

  factory :invalid_answer, class: Answer do
    body { nil }
    question
    user
  end
end
