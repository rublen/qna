module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy

    def change_vote_sum
      update(vote_sum: votes.sum(:voted))
    end

    def vote(user)
      votes.where(user: user)[0]
    end

    def voted?(user)
      !!(vote(user))
    end

    def upvoted?(user)
      vote(user)&.voted == 1
    end

    def downvoted?(user)
      vote(user)&.voted == -1
    end
  end
end