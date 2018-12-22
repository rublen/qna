require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :author }

  it { should validate_presence_of :body }

  it_should_behave_like "attachable"
  it_should_behave_like "votable"
  it_should_behave_like "commentable"

  it "sets default value 'false' for 'best' attribute" do
    expect(create(:answer)).to_not be_best
  end

  describe "#best answer" do
    let(:question) { create(:question) }
    let!(:answer_1) { create(:answer, question: question) }
    let!(:answer_2) { create(:answer, question: question, best: true) }

    context "validates question's number of best answers" do
      it 'returns error after attempt to have two questions with { best: true }' do
        answer_1.update(best: true)
        expect(answer_1.errors.full_messages).to include("Best answer: question can't have more than one")
      end
    end

    context "'mark_the_best' method" do
      it 'changes the answer with { best: true } for { best: false }' do
        answer_1.mark_the_best
        expect(answer_2.reload).to_not be_best
      end

      it 'updates the required answer with { best: true }' do
        answer_1.mark_the_best
        expect(answer_1.reload).to be_best
      end
    end
  end

  describe "#follow_question_mails" do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:subscription) { create(:subscription, user: user, question_id: question.id) }
    let!(:answer) { build(:answer, question: question) }

    it "should receive #follow_question_mails after create" do
      expect(answer).to receive(:follow_question_mails)
      answer.save
    end

    it 'should send emails to the question subscribers' do
      expect(FollowQuestionJob).to receive(:perform_later).with(question)
      answer.save
    end

    it "shoul not send email after update" do
      answer.save
      expect(answer).to_not receive(:follow_question_mails)
      answer.update(body: "123")
    end
  end
end
