FactoryBot.define do
  factory :answer do
    body { "AnswerBody" }
    question
    association :author, factory: :user
  end

  factory :invalid_answer, class: Answer do
    body { }
    question_id { }
    user_id { }
  end
end
