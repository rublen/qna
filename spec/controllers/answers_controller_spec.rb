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
            question_id: question }
        }.to change(question.answers, :count).by(1)
      end

      it 'saves a new answer in the DB in assosiation with user' do
        expect {
          post :create, params: {
            answer: attributes_for(:answer),
            question_id: question }
        }.to change(@user.answers, :count).by(1)
      end

      it 'redirects to questions/show view' do
        post :create, params: {
          answer: attributes_for(:answer),
          question_id: question
        }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the DB' do
        expect { post :create, params: {
          answer: attributes_for(:invalid_answer),
          question_id: question }
        }.to_not change(Answer, :count)
      end

      it 'renders questions/show view' do
        post :create, params: {
          answer: attributes_for(:invalid_answer),
          question_id: question
        }
        expect(response).to render_template 'questions/show'
      end
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
