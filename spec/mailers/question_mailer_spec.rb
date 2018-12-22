require "rails_helper"

RSpec.describe QuestionMailer, type: :mailer do

  describe ".fresh_answer" do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:subscription) { create(:subscription, user: user, question_id: question.id) }

    let(:mail) { QuestionMailer.fresh_answer(question, user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Fresh answer")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["qna@male.com"])
    end

    it "renders the body and include question's title" do
      expect(mail.body.encoded).to include(question.title)
    end

    it "renders the body and include 'Unfollow'" do
      expect(mail.body.encoded).to include('Unfollow')
    end
  end

end
