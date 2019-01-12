class VotesController < ApplicationController
  before_action :set_vote, only: %i[unvote]
  before_action :set_votable, only: %i[up down]

  authorize_resource only: :unvote

  def up
    authorize!(:up, @votable)
    set_new_vote_with_value 1
    act_voting(@vote, :save)
  end

  def down
    authorize!(:down, @votable)
    set_new_vote_with_value -1
    act_voting(@vote, :save)
  end

  def unvote
    @votable = @vote.votable
    act_voting(@vote, :destroy)
  end


  private

  def set_new_vote_with_value(voted_value)
    @vote = @votable.votes.new
    @vote.user = current_user
    @vote.voted = voted_value
  end

  def act_voting(vote, act)
    respond_to do |format|
      if vote.public_send(act)
        @votable.change_vote_sum
        publish_to_stream
        format.json { render_json_with_vote_results(vote) }
      else
        format.json { render_json_errors(vote) }
      end
    end
  end

  def set_vote
    @vote = Vote.find(params[:id])
  end

  def set_votable
    klass = [Question, Answer].detect{|c| params["#{c.name.underscore}_id"]}
    @votable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def render_json_with_vote_results(vote)
    render json: {
      vote_id: vote.id,
      votable_sum: @votable.vote_sum,
      up_voted: @votable.upvoted?(current_user),
      down_voted: @votable.downvoted?(current_user)
    }
  end

  def render_json_errors(item)
    render json: { error: item.errors.full_messages }, status: 422
  end

  def publish_to_stream
    ActionCable.server.broadcast("question-#{question_id}", { vote:
      { id: @vote.id,
        user_id: @vote.user_id,
        upvoted: @votable.upvoted?(current_user),
        downvoted: @votable.downvoted?(current_user),
        vote_sum: @votable.vote_sum,
        votable_id: @votable.id,
        votable_user_id: @votable.author.id,
        votable_css_id: "##{@vote.votable_type.underscore}-#{@votable.id}" }
    }.to_json) if @vote
  end

  def question_id
    @vote.votable_type == 'Question' ? @votable.id : @votable.question_id
  end
end
