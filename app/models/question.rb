class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'


  validates :title, :body, presence: true

  def best_answer
    answers.find_by(best: true)
  end
end
