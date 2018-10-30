class VotesController < ApplicationController
  include Voted

  before_action :set_vote, only: %i[unvote]
  before_action :set_votable, only: %i[up down]

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
