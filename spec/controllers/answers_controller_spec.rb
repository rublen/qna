require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }

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
      patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }

      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the requested question to @question' do
      patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }

      expect(assigns(:question)).to eq question
    end

    it "changes answer's attributes" do
      patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
      answer.reload

      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }

      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'author deletes the answer' do
      let!(:answer) { create(:answer, author: @user) }

      it 'assigns requested answer to @answer' do
        delete :destroy, params: { id: answer, format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'deletes answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to change(Answer, :count).by(-1)
      end

       it 'renders answers/destroy view' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template 'destroy'
      end
    end

    context 'not author can not delete the answer' do
      let!(:answer) { create(:answer, author: create(:user)) }
      it 'assigns requested answer to @answer' do
        delete :destroy, params: { id: answer, format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to_not change(Answer, :count)
      end

      it 'renders answers/destroy view' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template 'destroy'
      end
    end
  end

  describe "GET #best" do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let!(:answer_1) { create(:answer, question: question) }
    let!(:answer_2) { create(:answer, question: question) }

    context "assigning" do
      before do
        sign_in user
        get :best, params: { id: answer_1, format: :js }
      end

      it 'assigns requested answer to @answer' do
        expect(assigns(:answer)).to eq answer_1
      end

      it 'assigns the responsive question to @question' do
        expect(assigns(:question)).to eq answer_1.question
      end
    end

    context 'author chooses the best answer for his question' do
      before do
        sign_in user
        answer_2.update(best: true)
        get :best, params: { id: answer_1, format: :js }
      end

      it "answer's attribute 'best' changes for 'true'" do
        expect(answer_1.reload.best).to eq true
      end

      it "all of other answers of current question have { best: false }" do
        expect(answer_2.reload.best).to eq false
      end

       it 'renders answers/best view' do
        expect(response).to render_template 'best'
      end
    end

    context 'not author can not mark the answer as best' do
      sign_in_user
      # before { sign_in create(:user) }

      it 'tries to mark answer' do
        expect { get :best, params: { id: answer_1, format: :js } }.to_not change(answer_1, :best)
      end

      it 'renders answers/delete view' do
        get :best, params: { id: answer_1, format: :js }
        expect(response).to render_template 'best'
      end
    end
  end
end
