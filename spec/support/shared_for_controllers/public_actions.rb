require 'rails_helper'

RSpec.shared_examples_for "public_actions" do
  before { sign_out :user }
  let(:item) { create(:question) }

  describe 'GET #index' do
    it "responds with success" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    it "responds with success" do
      get :show, params: { id: item }
      expect(response.status).to eq(200)
    end
  end
end
