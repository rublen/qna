require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let!(:author) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, author: author) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question, author: author) }
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  # describe 'GET #edit' do
  #   sign_in_user
  #   let(:question) { create(:question, author: @user) }
  #   before { get :edit, params: { id: question } }

  #   it 'assigns the requested question to @question' do
  #     expect(assigns(:question)).to eq question
  #   end

  #   it 'renders edit view' do
  #     expect(response).to render_template :edit
  #   end
  # end

  describe 'POST #create' do
    sign_in_user
    context 'with valide attributes' do
      it 'saves a new question in the DB' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to questions_path' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to questions_path
      end
    end

    context 'with invalide attributes' do
      it 'does not save the question in the DB' do
        expect { post :create, params: { question: attributes_for(:invalid_question) }, format: :js }.to_not change(Question, :count)
      end

      it 'renders questions/create view' do
        post :create, params: { question: attributes_for(:invalid_question), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let(:question) { create(:question, author: @user) }

    context 'with valide attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new tit', body: 'new b'}, format: :js }
        question.reload
        expect(question.title).to eq 'new tit'
        expect(question.body).to eq 'new b'
      end

      it 'renders update template' do
        patch :update, params: { id: question, question: { title: 'new tit', body: 'new b'}, format: :js }
        expect(response).to render_template :update
      end
    end

    context 'with invalide attributes' do
      before do
        @title = question.title
        @body = question.body
        patch :update, params: { id: question, question: attributes_for(:invalid_question), format: :js }
      end

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq @title
        expect(question.body).to eq @body
      end

      it 'renders update template' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'author deletes question' do
      let!(:question) { create(:question, author: @user) }

      it 'deletes question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'not author can not delete the question' do
      let!(:question) { create(:question, author: author) }

      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to questions/index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end
end
