FactoryBot.define do
  factory :comment do
    association :commentable, factory: :answer
    association :author, factory: :user
    body { "answer's comment body" }
  end

  factory :question_comment, class: Comment do
    association :commentable, factory: :question
    association :author, factory: :user
    body { "question's comment body" }
  end

  factory :answer_comment, class: Comment do
    association :commentable, factory: :answer
    association :author, factory: :user
    body { "answer's comment body" }
  end
end
