class VotesController < ApplicationController
  include Voted

  def up
    set_new_vote_with_value 1
    act_voting(@vote, :save)
  end

  def down
    set_new_vote_with_value -1
    act_voting(@vote, :save)
  end

  def unvote
    @votable = @vote.votable
    act_voting(@vote, :destroy)
  end
end
