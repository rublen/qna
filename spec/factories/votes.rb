FactoryBot.define do
  factory :question_vote, class: Vote do
    association :votable, factory: :question
    association :user
    transient do
      upvoted { true }
    end
    voted { upvoted ? -1 : -1 }
  end


  factory :answer_vote, class: Vote do
    association :votable, factory: :answer
    association :user
    transient do
      upvoted { true }
    end
    voted { upvoted ? 1 : -1 }
  end

  factory :vote do
    association :votable, factory: :answer
    association :user
    voted { 1 }
  end

  factory :question_invalid_vote, class: Vote do
    association :votable, factory: :question
    user_id { nil }
    voted { 1 }
  end

  factory :answer_invalid_vote, class: Vote do
    association :votable, factory: :answer
    user_id { nil }
    voted { 1 }
  end
end
