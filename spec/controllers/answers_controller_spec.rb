require 'rails_helper'
require_relative 'shared_examples/voted_spec'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'

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
    let(:author) { create(:user) }
    let!(:answer) { create :answer, question: question, author: author }

    context 'The author updates his answer' do
      before { sign_in(author) }

      describe 'Assigning' do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js } }

        it 'assigns requested answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq question
        end
      end

      describe 'With valid attributes' do
        it "changes answer's attributes" do
          patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'renders answers/update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }

          expect(response).to render_template :update
        end
      end

      describe 'With invalid attributes' do
        it "doesn't change answer's attributes" do
          expect { patch :update, params: { id: answer, answer: { body: '' }, format: :js } }.to_not change(answer, :body)
        end

        it 'renders answers/update view' do
          patch :update, params: { id: answer, answer: { body: '' }, format: :js }

          expect(response).to render_template :update
        end
      end
    end

    context 'Not author tries to update the answer' do
      before { sign_in(create(:user)) }

      it "doesn't change answer's attributes" do
        expect { patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js } }.to_not change(answer, :body)
      end

      it "recieves the flash-message about no permission for this action" do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }

        expect(flash[:alert]).to eq 'This action is permitted only for author.'
      end

      it 'renders answers/update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }

        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'The author deletes the answer' do
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

    context 'Not author can not delete the answer' do
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

  describe "PATCH #best" do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let!(:answer_1) { create(:answer, question: question) }
    let!(:answer_2) { create(:answer, question: question) }

    context "Assigning" do
      before do
        sign_in user
        patch :best, params: { id: answer_1, format: :js }
      end

      it 'assigns requested answer to @answer' do
        expect(assigns(:answer)).to eq answer_1
      end

      it 'assigns the responsive question to @question' do
        expect(assigns(:question)).to eq answer_1.question
      end
    end

    context 'The author chooses the best answer for his question' do
      before do
        sign_in user
        answer_2.update(best: true)
        patch :best, params: { id: answer_1, format: :js }
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

    context 'Not author can not mark the answer as best' do
      sign_in_user

      it 'tries to mark answer' do
        expect { patch :best, params: { id: answer_1, format: :js } }.to_not change(answer_1, :best)
      end

      it 'renders answers/delete view' do
        patch :best, params: { id: answer_1, format: :js }
        expect(response).to render_template 'best'
      end
    end
  end
end
