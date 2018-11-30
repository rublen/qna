require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let!(:user) { create(:user) }
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET #facebook (with email)' do

    context "For existing user" do
      let!(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
      before do
        request.env['omniauth.auth'] = auth
        get :facebook
      end

      it 'finds and assigns the requested user to @user' do
        expect(assigns(:user)).to eq user
      end

      it 'sets current_user' do
        expect(subject.current_user).to eq user
      end

      it 'sets :notice flash' do
        expect(flash[:notice]).to include("Successfully authenticated")
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context "For unexisting user" do
      let!(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new_user@mail.com' }) }

      before { request.env['omniauth.auth'] = auth }

      it 'creats new user with given email' do
        expect { get :facebook }.to change(User, :count).by(1)
        expect(User.find_by(email: 'new_user@mail.com')).to_not be_nil
      end

      it 'finds and assigns the requested user to @user' do
        get :facebook
        user = User.find_by(email: 'new_user@mail.com')
        expect(assigns(:user)).to eq user
      end

      it 'sets current_user' do
        get :facebook
        user = User.find_by(email: 'new_user@mail.com')
        expect(subject.current_user).to eq user
      end

      it 'sets :notice flash' do
        get :facebook
        expect(flash[:notice]).to include("Successfully authenticated")
      end

      it 'redirects to root_path' do
        get :facebook
        expect(response).to redirect_to(root_path)
      end
    end
  end


  describe 'GET #github (without email)' do
    let!(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: {}) }
    before { request.env['omniauth.auth'] = auth }

    context "For existing user's authorization" do
      let(:authorization) { create(:authorization) }
      let(:user) { authorization.user }

      before { get :github }

      it "doesn't creat new user" do
        expect { get :github }.to_not change(User, :count)
      end

      it 'finds and assigns the requested user to @user' do
        expect(assigns(:user)).to eq user
      end

      it 'sets current_user' do
        expect(subject.current_user).to eq user
      end

      it 'sets :notice flash' do
        expect(flash[:notice]).to include("Successfully authenticated")
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context "For unexisting authorization" do
      it 'creats temporary user with fake email' do
        expect { get :github }.to change(User, :count).by(1)
        expect(User.last.email).to eq "oauth-#{User.maximum('id').to_i}@temp-mail.com"
      end

      it 'finds and assigns the requested user to @user' do
        get :github
        user = User.find_by(email: "oauth-#{User.maximum('id').to_i}@temp-mail.com")
        expect(assigns(:user)).to eq user
      end

      it "doesn't sets current_user" do
        get :github
        expect(subject.current_user).to be_nil
      end

      it "renders 'oauth_enter_email'" do
        get :github
        expect(response).to render_template "omniauth_callbacks/oauth_enter_email"
      end
    end
  end

  describe 'PATCH #oauth_update_email' do
    let(:temp_user) { create(:user, email: 'fake@mail.com') }
    let!(:authorization) { create(:authorization, user: temp_user, confirmed: false) }

    context "With email of existing user" do
      let(:real_email) { user.email }

      it "destroys temporary user and its authorization" do
        expect { patch :oauth_update_email, params: { id: temp_user.id, user: { email: real_email } } }.to change(User, :count).by(-1)
        expect(Authorization.find_by(user: temp_user)).to be_nil
      end

      it "creates authorization for found user" do
        patch :oauth_update_email, params: { id: temp_user.id, user: { email: real_email } }
        user = User.find_by(email: real_email)
        expect(user.authorizations).to_not be_empty
      end

      it "signs in found user with given provider" do
        patch :oauth_update_email, params: { id: temp_user.id, user: { email: real_email } }
        expect(subject.current_user).to eq User.find_by(email: real_email)
      end
    end

    context "With email of unexisting user" do
      let(:real_email) { 'real@mail.com' }

      it "doesn't change amount of users" do
        expect { patch :oauth_update_email, params: { id: temp_user.id, user: { email: real_email } } }.to_not change(User, :count)
      end

      it "updates temp_user with real email" do
        patch :oauth_update_email, params: { id: temp_user.id, user: { email: real_email } }
        expect(temp_user.reload.email).to eq real_email
      end

      it "updates temp_user's authorization with 'confirmed: true'" do
        patch :oauth_update_email, params: { id: temp_user.id, user: { email: real_email } }
        expect(temp_user.authorizations.last.confirmed).to be true
      end

      it "signs in found temp_user with given provider" do
        patch :oauth_update_email, params: { id: temp_user.id, user: { email: real_email } }
        expect(subject.current_user).to eq User.find_by(email: real_email)
      end
    end
  end
end
