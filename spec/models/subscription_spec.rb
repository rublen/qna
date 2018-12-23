require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to :user }
  it { should belong_to(:question) }

  it { should validate_uniqueness_of(:question_id).scoped_to(:user_id) }

  describe "belongs_to :question, optional: true" do
    it "creates subscription without question" do
      expect { create(:subscription, question: nil) }.to change(Subscription, :count).by(1)
    end
  end

  describe ".daily scope" do
    let(:subscription) { create :subscription }
    let(:daily_subscription) { create :daily_subscription }

    it "returns only daily subscriptions" do
      expect(Subscription.daily).to match [daily_subscription]
    end
  end
end
