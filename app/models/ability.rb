class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user
      if user.admin?
        can :manage, :all
        # cannot [:up, :down], Vote do |vote|
        #   user.author_of?(vote.votable)
        # end
        # cannot :unvote, Vote do |vote|
        #   !user.author_of?(vote)
        # end
      else
        can :read, :all
        can :create, :all
        can [:update, :destroy], [Question, Answer, Comment], user_id: user.id
        can :best, Answer do |answer|
          user.author_of?(answer.question)
        end
        can :destroy, Attachment do |attachment|
          user.author_of?(attachment.attachable)
        end
        can [:up, :down], Vote do |vote|
          !user.author_of?(vote.votable)
        end
        can :unvote, Vote, user_id: user.id
      end
    else
      can :read, :all
    end
  end
end
