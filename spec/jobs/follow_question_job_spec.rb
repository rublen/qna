require 'rails_helper'

RSpec.describe FollowQuestionJob, type: :job do

  # keep in mind: there is callback "after_create :subscribe_author" in Question model
    let!(:question) { create(:question) }

  describe "#perform" do

    it "should send 2 letters" do
      allow(nil).to receive(:deliver_later)
      create(:subscription, question_id: question.id)
      create(:subscription)

      expect(QuestionMailer).to receive(:fresh_answer).exactly(2).times
      FollowQuestionJob.perform_now(question)
    end

    it "should not send letter if noone follows question" do
      Subscription.delete_all
      expect(QuestionMailer).to_not receive(:fresh_answer)
      FollowQuestionJob.perform_now(question)
    end

    it "should pass proper params to QuestionMailer's method 'fresh_answer'" do
      Subscription.delete_all
      subscription = create(:subscription, question_id: question.id)
      expect(QuestionMailer).to receive(:fresh_answer).with(question, subscription.user).and_call_original
      FollowQuestionJob.perform_now(question)
    end
  end
end

