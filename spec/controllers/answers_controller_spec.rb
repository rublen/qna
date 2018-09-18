require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }

  describe 'GET #show' do
    sign_in_user
    let(:answer) { create(:answer, question: question) }
    before { get :show, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template 'show'
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new, params: { question_id: question }  }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves a new answer in the DB' do
        expect { post :create, params: {
          answer: attributes_for(:answer),
          question_id: question }
        }.to change(question.answers, :count).by(1)
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
end
