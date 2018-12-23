require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let(:mail) { DailyMailer.digest(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["qna@male.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("new questions")
    end

    it "renders the body and include question's title" do
      expect(mail.body.encoded).to include(question.title)
    end
  end
end
