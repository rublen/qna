class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    @user ||= User.new # guest user (not logged in)
    if @user
      if @user.admin?
        admin_abilities
      else
        user_abilities
      end
    else
      guest_abilities
    end
  end

  private
  attr_reader :user

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    can :read, :all
    can :create, :all

    can [:update, :destroy], [Question, Answer, Comment], author: user
    can :best, Answer, question: { author: user }

    can :destroy, Attachment, attachable: { author: user }

    can [:up, :down], Vote do |vote|
      !user.author_of?(vote.votable)
    end
    can :unvote, Vote, user: user
  end
end
