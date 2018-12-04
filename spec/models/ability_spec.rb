require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  context 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Attachment }
    it { should be_able_to :read, Vote }

    it { should_not be_able_to :manage, :all }
  end

  context 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  context 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let!(:answer) { create(:answer) }


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :create, :all }

    it { should be_able_to :update, create(:question, author: user), user: user }
    it { should_not be_able_to :update, create(:question, author: other), user: user }

    it { should be_able_to :destroy, create(:question, author: user), user: user }
    it { should_not be_able_to :destroy, create(:question, author: other), user: user }

    it { should be_able_to :update, create(:answer, author: user), user: user }
    it { should_not be_able_to :update, create(:answer, author: other), user: user }

    it { should be_able_to :destroy, create(:answer, author: user), user: user }
    it { should_not be_able_to :destroy, create(:answer, author: other), user: user }

    # it { should be_able_to :update, create(:comment, user_id: user.id), user: user }
    # it { should_not be_able_to :update, create(:comment, user_id: other.id), user: user }

    it { should be_able_to :destroy, create(:comment, user_id: user.id), user: user }
    it { should_not be_able_to :destroy, create(:comment, user_id: other.id), user: user }

    it { should be_able_to :best, answer, user: answer.question.author }
    it { should_not be_able_to :best, answer, user: user }

    it { should be_able_to :destroy, create(:attachment, attachable: answer), user: answer.author }
    it { should_not be_able_to :destroy, create(:attachment, attachable: answer), user: user }

    it { should be_able_to :up, answer.votes.new(voted: 1), user: user }
    it { should_not be_able_to :up, answer.votes.new(voted: 1), user: answer.author }

    it { should be_able_to :down, answer.votes.new(voted: -1), user: user }
    it { should_not be_able_to :down, answer.votes.new(voted: -1), user: answer.author }

    it { should be_able_to :unvote, create(:vote, votable: answer, user: user), user: user }
    it { should_not be_able_to :unvote, create(:vote, votable: answer, user: user), user: other }
  end
end
