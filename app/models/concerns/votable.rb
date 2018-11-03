module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy

    def change_vote_sum
      update!(vote_sum: votes.sum(:voted))
    end

    def vote_by(user)
      votes.where(user: user).first
    end

    def voted?(user)
      !!(vote_by(user))
    end

    def upvoted?(user)
      vote_by(user)&.voted == 1
    end

    def downvoted?(user)
      vote_by(user)&.voted == -1
    end
  end
end
