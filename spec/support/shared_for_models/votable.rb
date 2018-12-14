require 'rails_helper'

RSpec.shared_examples_for "votable" do
  it { should have_many(:votes).dependent(:destroy) }

  let(:votable) { create(described_class.model_name.to_s.underscore.to_sym) }

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  let!(:vote) { create(:vote, votable: votable, user: user) }
  let!(:downvote) { create(:vote, votable: votable, user: other_user, voted: -1) }

  it "updates votable's vote_sum with actual data" do
    downvote
    vote.update(voted: -1)
    votable.change_vote_sum
    expect(votable.vote_sum).to eq -2
  end

  it "finds user's vote for the votable" do
    expect(votable.vote_by(user)).to eq vote
  end

  it "returns 'true' if user has voted for this item" do
    expect(votable.voted?(user)).to be true
  end

  it "returns 'false' if user hasn't voted for this item" do
    expect(votable.voted?(create(:user))).to be false
  end

  it "returns 'true' if user has upvoted for this item" do
    expect(votable.upvoted?(user)).to be true
  end

  it "returns 'false' if user hasn't upvoted for this item" do
    expect(votable.upvoted?(other_user)).to be false
  end

  it "returns 'true' if user has downvoted for this item" do
        expect(votable.downvoted?(other_user)).to be true
  end

  it "returns 'false' if user hasn't downvoted for this item" do
    expect(votable.downvoted?(user)).to be false
  end
end
