require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  describe "GET #search" do
    let!(:user) { create :user, email: 'xxx@mail.com' }
    let!(:question_1) { create :question, title: 'xxx q_title' }
    let!(:question_2) { create :question, body: 'xxx q_body' }
    let!(:answer_1) { create :answer, body: 'xxx a_body' }
    let!(:answer_2) { create :answer, author: user }
    let!(:comment) { create :comment, body: 'xxx c_body' }
    let(:search_results) { [question_1, question_2, answer_1, answer_2, comment, user] }

    it "returns http success" do
      get :search
      expect(response).to have_http_status(:success)
    end

    it "returns empty body for empty search request" do
      get :search
      expect(response.body).to be_empty
    end

    it "full search: populates @items with an array of search results" do
      allow(ThinkingSphinx).to receive(:search).with('xxx', limit: 500) { search_results }
      get :search, params: { search: 'xxx' }
      expect(assigns(:items)).to match_array search_results
    end

    it "question search: populates @items with an array of found questions" do
      allow(Question).to receive(:search).with('xxx', limit: 500) { [question_1, question_2] }
      get :search, params: { search: 'xxx', search_options: 'Question' }
      expect(assigns(:items)).to match_array [question_1, question_2]
    end

    it "answer search: populates @items with an array of found answers" do
      allow(Answer).to receive(:search).with('xxx', limit: 500) { [answer_1, answer_2] }
      get :search, params: { search: 'xxx', search_options: 'Answer' }
      expect(assigns(:items)).to match_array [answer_1, answer_2]
    end

    it "comment search: populates @items with an array of found comments" do
      allow(Comment).to receive(:search).with('xxx', limit: 500) { [comment] }
      get :search, params: { search: 'xxx', search_options: 'Comment' }
      expect(assigns(:items)).to match_array [comment]
    end

    it "user search: populates @items with an array of found questions" do
      allow(User).to receive(:search).with('xxx', limit: 500) { [user] }
      get :search, params: { search: 'xxx', search_options: 'User' }
      expect(assigns(:items)).to match_array [user]
    end
  end
end
