class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question, optional: true

  validates :question_id, uniqueness: { scope: [:user_id] }

  scope :daily, -> { where question_id: nil }
end
