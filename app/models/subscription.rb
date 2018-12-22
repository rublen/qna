class Subscription < ApplicationRecord
  belongs_to :user
  validates :question_id, presence: true
  validates :question_id, uniqueness: { scope: [:user_id] }
end
