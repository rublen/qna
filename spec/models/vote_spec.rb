require 'rails_helper'

RSpec.describe Vote, type: :model do
  let!(:vote) { create(:vote) }

  it { should belong_to :votable }
  it { should belong_to :user }

  it { should validate_uniqueness_of(:user_id).scoped_to(:votable_type, :votable_id) }
  it { should validate_inclusion_of(:voted).in_array([-1, 1]) }
end
