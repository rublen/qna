require 'rails_helper'

RSpec.describe DailyMailerJob, type: :job do
  describe "#perform" do
    let!(:users) { create_list(:user, 2) }
    let!(:unsubscribed_user) { create(:user) }

    before { create(:daily_subscription, user: users.last) }

    context "List of today's questions is not empty" do
      before { create :question, author: users.first }

      it "should send 2 letters" do
        allow(nil).to receive(:deliver_now)
        expect(DailyMailer).to receive(:digest).exactly(2).times
        subject.perform_now
      end

      it "should not send letter to unsubscribed user" do
        allow(nil).to receive(:deliver_now)
        expect(DailyMailer).to_not receive(:digest).with(unsubscribed_user)
        subject.perform_now
      end
    end

    context "List of today's questions is empty" do
      it "should not send letters" do
        expect(DailyMailer).to_not receive(:digest)
        subject.perform_now
      end
    end
  end

  context "Enqueued job" do
    it "matches with enqueued job" do
      ActiveJob::Base.queue_adapter = :test
      expect { DailyMailerJob.perform_later }.to have_enqueued_job(DailyMailerJob).with(no_args)
    end
  end
end
