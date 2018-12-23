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

    can [:update, :destroy], [Question, Answer, Comment], user_id: user.id
    can :best, Answer, question: { user_id: user.id }

    can :destroy, Attachment, attachable: { user_id: user.id }

    can [:up, :down, :vote], [Question, Answer] do |resource|
      !user.author_of?(resource) && !resource.voted?(user)
    end
    can :unvote, Vote, user: user

    can :create_daily_subscription, Subscription, user_id: user.id
    can :destroy, Subscription, user_id: user.id
  end
end
