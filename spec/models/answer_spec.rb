require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_many(:attachments).dependent(:destroy) }
  it { should belong_to :question }
  it { should belong_to :author }

  it { should accept_nested_attributes_for :attachments }

  it { should validate_presence_of :body }

  it "sets default value 'false' for 'best' attribute" do
    expect(create(:answer)).to_not be_best
  end

  describe "best answer" do
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
end
