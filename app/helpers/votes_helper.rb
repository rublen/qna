module VotesHelper
  def upvote_path(votable)
    polymorphic_path([:up, votable, Vote])
  end

  def downvote_path(votable)
    polymorphic_path([:down, votable, Vote])
  end
end
