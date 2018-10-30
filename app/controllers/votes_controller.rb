class VotesController < ApplicationController
  include Voted

  before_action :set_vote, only: %i[unvote]
  before_action :set_votable, only: %i[up down]

  def up
    unless current_user.author_of?(@votable)
      set_new_vote_with_value 1
      act_voting(@vote, :save)
    end
  end

  def down
    unless current_user.author_of?(@votable)
      set_new_vote_with_value -1
      act_voting(@vote, :save)
    end
  end

  def unvote
    if current_user.author_of?(@vote)
      @votable = @vote.votable
      act_voting(@vote, :destroy)
    end
  end
end

