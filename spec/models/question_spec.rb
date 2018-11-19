require 'rails_helper'
require_relative 'concerns/attachable_spec'
require_relative 'concerns/votable_spec'
require_relative 'concerns/commentable_spec'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should belong_to(:author) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it_should_behave_like "attachable"
  it_should_behave_like "votable"
  it_should_behave_like "commentable"

  describe "'best_answer' method" do
    let(:question) { create(:question) }
    let!(:answer_1) { create(:answer, question: question) }
    let!(:answer_2) { create(:answer, question: question, best: true) }

    it 'returns answer with { best: true }' do
      expect(question.best_answer).to eq answer_2
    end
  end
end
