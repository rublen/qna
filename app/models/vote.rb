class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true, touch: true
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id] }
  validates :voted, inclusion: { in: [-1, 1] }
end
