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
    let!(:user_answer) { create(:answer, author: user) }
    let!(:other_answer) { create(:answer, author: other) }


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :create, :all }

    it { should be_able_to :update, create(:question, author: user), user: user }
    it { should_not be_able_to :update, create(:question, author: other), user: user }

    it { should be_able_to :destroy, create(:question, author: user), user: user }
    it { should_not be_able_to :destroy, create(:question, author: other), user: user }

    it { should be_able_to :update, user_answer, user: user }
    it { should_not be_able_to :update, other_answer, user: user }

    it { should be_able_to :destroy, user_answer, user: user }
    it { should_not be_able_to :destroy, other_answer, user: user }

    # updating comments hasn't performed yet
    # it { should be_able_to :update, create(:comment, user_id: user.id), user: user }
    # it { should_not be_able_to :update, create(:comment, user_id: other.id), user: user }

    it { should be_able_to :destroy, create(:comment, user_id: user.id), user: user }
    it { should_not be_able_to :destroy, create(:comment, user_id: other.id), user: user }

    it { should be_able_to :best, create(:answer, question: create(:question, author: user)), user: user }
    it { should_not be_able_to :best, other_answer, user: user }

    it { should be_able_to :destroy, create(:attachment, attachable: user_answer), user: user }
    it { should_not be_able_to :destroy, create(:attachment, attachable: other_answer), user: user }

    it { should be_able_to :up, other_answer, user: user }
    it { should_not be_able_to :up, user_answer, user_id: user.id }

    it { should be_able_to :down, other_answer, user: user }
    it { should_not be_able_to :down, user_answer, user: user }

    it { should be_able_to :unvote, create(:vote, user: user), user: user }
    it { should_not be_able_to :unvote, create(:vote), user: other }

    it { should be_able_to :destroy, create(:subscription, user: user), user: user }
    it { should_not be_able_to :destroy, create(:subscription, user: other), user: user }
  end
end
