require 'rails_helper'

RSpec.describe FollowQuestionJob, type: :job do
  describe "#perform" do
    let!(:question_1) { create(:question) }
    let!(:question_2) { create(:question) }
    let!(:subscription_1) { create(:subscription, question_id: question_1.id) }

    it "should send 2 letters" do
      allow(nil).to receive(:deliver_now)
      expect(QuestionMailer).to receive(:fresh_answer).exactly(2).times
      FollowQuestionJob.perform_now(question_1)
    end

    it "should not send letter about another question" do
      Subscription.find_by(question_id: question_2).delete
      expect(QuestionMailer).to_not receive(:fresh_answer)
      FollowQuestionJob.perform_now(question_2)
    end

    it "should pass proper params to QuestionMailer method 'fresh_answer'" do
      allow(nil).to receive(:deliver_now)
      Subscription.delete_all
      subscription = create(:subscription, question_id: question_1.id)
      expect(QuestionMailer).to receive(:fresh_answer).with(question_1, subscription.user)
      FollowQuestionJob.perform_now(question_1)
    end
  end

  context "Enqueued job" do
    let!(:question_1) { create(:question) }
    it "matches with enqueued job" do
      ActiveJob::Base.queue_adapter = :test
      expect { FollowQuestionJob.perform_later(question_1) }.to have_enqueued_job(FollowQuestionJob).with(question_1)
    end
  end
end
