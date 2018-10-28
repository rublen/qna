module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_vote, only: %i[unvote]
    before_action :set_votable, only: %i[up down]

    def set_new_vote_with_value(voted_value)
      @vote = @votable.votes.new()
      @vote.user = current_user
      @vote.voted = voted_value
    end

    def act_voting(vote, act)
      respond_to do |format|
        unless current_user.author_of?(@votable)
          if vote.send(act)
            @votable.change_vote_sum
            format.json { render_json_with_vote_results(vote) }
          else
            format.json { render_json_errors(vote) }
          end
        end
      end
    end

  end

  private
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
      up_voted: @votable.up_voted?(current_user),
      down_voted: @votable.down_voted?(current_user)
    }
  end

  def render_json_errors(item)
    render json: { error: item.errors.full_messages }, status: 422
  end
end
