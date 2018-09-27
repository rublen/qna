require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:author) { create(:user) }
  let!(:question) { create(:question, author: author) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves a new answer in the DB in assosiation with question' do
        expect {
          post :create, params: {
            answer: attributes_for(:answer),
            question_id: question,
            format: :js }
        }.to change(question.answers, :count).by(1)
      end

      it 'saves a new answer in the DB in assosiation with user' do
        expect {
          post :create, params: {
            answer: attributes_for(:answer),
            question_id: question,
            format: :js }
        }.to change(@user.answers, :count).by(1)
      end

      it 'renders answers/create view' do
        post :create, params: {
          answer: attributes_for(:answer),
          question_id: question,
          format: :js }

        expect(response).to render_template 'answers/create'
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the DB' do
        expect { post :create, params: {
          answer: attributes_for(:invalid_answer),
          question_id: question,
          format: :js }
        }.to_not change(Answer, :count)
      end

      it 'renders answers/create view' do
        post :create, params: {
          answer: attributes_for(:invalid_answer),
          question_id: question,
          format: :js }

        expect(response).to render_template 'answers/create'
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let!(:answer) { create :answer, question: question, author: @user }

    it 'assigns requested answer to @answer' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }

      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the requested question to @question' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }

      expect(assigns(:question)).to eq question
    end

    it "changes answer's attributes" do
      patch :update, params: { id: answer, question_id: question, answer: { body: 'new body' }, format: :js }
      answer.reload

      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }

      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'author deletes the answer' do
      let!(:answer) { create(:answer, author: @user) }

      it 'deletes answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to questions/show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'not author can not delete the answer' do
      let!(:answer) { create(:answer, author: author) }

      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to questions/show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
