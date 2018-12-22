require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  describe "GET #create" do
    sign_in_user
    let(:question) { create(:question) }

    it "returns http success" do
      post :create, params: { question_id: question }
      expect(response).to have_http_status(:success)
    end

    it 'saves a new subscription in the DB in association with user' do
      expect { post :create, params: { question_id: question } }.to change(@user.subscriptions, :count).by(1)
    end
  end

  describe "GET #destroy" do
    let!(:subscription) { create(:subscription) }
    let(:user) { subscription.user }
    before { sign_in user }

    context 'User can delete his subscription' do
      it "returns http success" do
        delete :destroy, params: { id: subscription }
        expect(response).to have_http_status(:success)
      end

      it 'deletes attacment for the answer' do
        expect { delete :destroy, params: { id: subscription } }.to change(user.subscriptions, :count).by(-1)
      end
    end

    context 'Other user can not delete the subscription' do
      sign_in_user
      let!(:subscription) { create(:subscription) }

      it 'assigns requested subscription to @subscription' do
        delete :destroy, params: { id: subscription }
        expect(assigns(:subscription)).to eq subscription
      end

      it 'tries to delete attachment' do
        expect { delete :destroy, params: { id: subscription } }.to_not change(Subscription, :count)
      end
    end
  end
end
