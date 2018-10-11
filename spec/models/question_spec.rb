require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should belong_to(:author) }

  it { should accept_nested_attributes_for :attachments }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe "'best_answer' method" do
    let(:question) { create(:question) }
    let!(:answer_1) { create(:answer, question: question) }
    let!(:answer_2) { create(:answer, question: question, best: true) }

    it 'returns answer with { best: true }' do
      expect(question.best_answer).to eq answer_2
    end
  end
end
