class VotesController < ApplicationController
  before_action :set_vote, only: %i[unvote]

  def up
    @vote = Vote.new(vote_params)
    @vote.voted = 1
    p @vote
    raise params.inspect
    respond_to do |format|
      if current_user != @vote.votable.author
        if @vote.save
          @vote.votable.vote_sum += 1
          format.json { render json: @vote }
        else
          format.json { render json: @vote.errors.full_messages }
        end
      else
        format.html { render html: '<h2>The author can not vote for his creation</h2>'}
      end
    end
  end

  def down
    @vote = Vote.new()
    @vote.voted = -1
    @vote.user_id = current_user.id
    if current_user != @vote.votable.author
      if @vote.save
        @vote.votable.vote_sum -= 1
      end
    end
  end

  def unvote
    @vote.destroy
  end

  private
  def set_vote
    @vote = Vote.find(params[:id])
  end

  def vote_params
    params.require(:vote).permit(:votable_id, :votable_type, :user_id)
  end
end
