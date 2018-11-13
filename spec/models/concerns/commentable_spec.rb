require 'rails_helper'

RSpec.shared_examples_for "commentable" do
  it { should have_many(:comments).dependent(:destroy) }

  # let(:votable) { create(described_class.model_name.to_s.underscore.to_sym) }

  # let(:user) { create(:user) }
  # let(:other_user) { create(:user) }

  # let!(:vote) { create(:vote, votable: votable, user: user) }
  # let!(:downvote) { create(:vote, votable: votable, user: other_user, voted: -1) }
end
