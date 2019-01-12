require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should belong_to(:author) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it_should_behave_like "attachable"
  it_should_behave_like "votable"
  it_should_behave_like "commentable"

  let(:question) { build(:question) }

  describe "#best_answer" do
    let!(:answer_1) { create(:answer, question: question) }
    let!(:answer_2) { create(:answer, question: question, best: true) }

    it 'returns answer with { best: true }' do
      expect(question.best_answer).to eq answer_2
    end
  end

  describe "after_create callback #subscribe_author" do
    it "subscribes user for this question" do
      expect { question.save }.to change(question.subscriptions, :count).by(1)
    end
  end

  describe ".last_day_list scope" do
    let(:old_question) { create(:question, created_at: Time.now - 2.day) }
    before { question.save }

    it 'include fresh question' do
      expect(Question.last_day_list).to include(question)
    end

    it 'does not include old question' do
      expect(Question.last_day_list).to_not include(old_question)
    end
  end
end
