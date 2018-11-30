require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let!(:user) { create(:user) }

  describe 'Authorship' do
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

    context 'User already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'User exists but has no authorization' do
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

    context 'User does not exist in DB' do
      describe "but we have user's email" do
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

      describe "and we have no user's email" do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: {}) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a User
        end

        it "fills user's email with temporary email" do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq "oauth-#{user.id}@temp-mail.com"
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

  describe '#confirmed?(provider)' do
    it "returns 'true' as a default value" do
      user.authorizations.create(provider: 'github', uid: '123456')
      expect(user.confirmed?('github')).to be true
    end

    it "returns 'confirmed' attribute's value of authorization" do
      user.authorizations.create(provider: 'github', uid: '123456', confirmed: false)
      expect(user.confirmed?('github')).to be false
    end
  end

  describe '#oauth_confirm_email(provider, uid, email)' do
    let!(:temp_user) { create(:user, email: 'fake@mail.com') }
    let!(:authorization) { create(:authorization, user: temp_user, confirmed: false) }

    context "Got email of existing user" do
      it "destroys temporary user with fake email" do
        expect { temp_user.oauth_confirm_email('github', '123456', user.email) }.to change(User, :count).by(-1)
      end

      it 'creates authorization with provider and uid for user' do
        expect { temp_user.oauth_confirm_email('github', '123456', user.email) }.to change(user.authorizations, :count).by(1)
        expect(user.authorizations.last.confirmed).to be true
      end

      it 'returns the user' do
        expect(temp_user.oauth_confirm_email('github', '123456', user.email)).to eq user
      end
    end

    context "Got email of unexisting user" do
      it "doesn't change amount of users" do
        expect { temp_user.oauth_confirm_email('github', '123456', 'real@mail.com') }.to_not change(User, :count)
      end

      it "updates temporary user with real email" do
        temp_user.oauth_confirm_email('github', '123456', 'real@mail.com')
        expect(temp_user.email).to eq "real@mail.com"
      end

      it "updates authorization attribute 'confirmed' with value 'true'" do
        temp_user.oauth_confirm_email('github', '123456', 'real@mail.com')
        expect(temp_user.authorizations.last.confirmed).to be true
      end

      it 'returns the same user' do
        expect(temp_user.oauth_confirm_email('github', '123456', 'real@mail.com')).to eq temp_user
      end
    end
  end
end
