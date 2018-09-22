require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create(:user) }

  describe 'checks authorship' do
    let(:question) { create(:question, author: user) }
    let(:answer) { create(:answer, author: user) }
    let(:user1) { create(:user) }

    it "checks question's authorship" do
      expect(user.author_of? question).to eq true
      expect(user1.author_of? question).to eq false
    end

    it "checks answer's authorship" do
      expect(user.author_of? answer).to eq true
      expect(user1.author_of? answer).to eq false
    end
  end
end
