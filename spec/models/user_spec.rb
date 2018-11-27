require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }
  it { should have_many(:authorizations) }

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

  describe '.find_for_oauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user exists but has no authorization' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

      it 'creates authorization for user' do
        expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
      end

      it 'creates authorization with provider and uid' do
        user = User.find_for_oauth(auth)
        authorization = user.authorizations.first
        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'returns the user' do
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user does not exist' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

      it 'creates new user' do
        expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(User.find_for_oauth(auth)).to be_a User
      end

      it "fills user's email" do
        user = User.find_for_oauth(auth)
        expect(user.email).to eq auth.info[:email]
      end

      it 'creates authorization for user' do
        user = User.find_for_oauth(auth)
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorization with provider and uid' do
        user = User.find_for_oauth(auth)
        authorization = user.authorizations.first
        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end
end
