FactoryBot.define do
  factory :attachment do
    file { File.new("#{Rails.root}/spec/rails_helper.rb") }
    association :attachable, factory: :answer
  end

  factory :answer_attach, class: Attachment do
    file { File.new("#{Rails.root}/spec/rails_helper.rb") }
    association :attachable, factory: :answer
  end

  factory :question_attach, class: Attachment do
    file { File.new("#{Rails.root}/spec/rails_helper.rb") }
    association :attachable, factory: :question
  end
end
