class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  #validates :votable, uniqueness: [:votable_type, :votable_id, :user_id]
  #validates :votable, only_values: [-1, 0, 1]
end
