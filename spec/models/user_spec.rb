require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create(:user) }

  describe 'authorship' do
    let(:question) { create(:question, author: user) }
    let(:user1) { create(:user) }

    it "checks authorship" do
      expect(user).to be_author_of(question)
    end

    it "checks not-authorship" do
      expect(user1).to_not be_author_of(question)
    end
  end
end
