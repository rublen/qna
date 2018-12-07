require 'rails_helper'
require_relative 'shared_examples/public_actions_spec'
require_relative 'shared_examples/voted_spec'
require_relative 'shared_examples/commented_spec'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like "public_actions"
  it_behaves_like 'voted'
  it_behaves_like 'commented'

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

    it "assigns the array of question's answers to @answers" do
      expect(assigns(:answers)).to match_array question.answers
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

    it 'assigns a new attachment for @question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

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
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 'renders questions/new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }

    context 'The author updates his question' do
      before { sign_in(author) }

      describe 'With valide attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }
          expect(assigns(:question)).to eq question
        end

        it "changes question's attributes" do
          patch :update, params: { id: question, question: { title: 'new tit', body: 'new b'}, format: :js }
          question.reload
          expect(question.title).to eq 'new tit'
          expect(question.body).to eq 'new b'
        end

        it 'renders update template' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }
          expect(response).to render_template :update
        end
      end

      describe 'With invalide attributes' do
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

    context 'Not author tries to update the question' do
      before { sign_in(create(:user)) }

      it "doesn't change question's attributes" do
        expect { patch :update, params: { id: question, question: attributes_for(:invalid_question), format: :js } }.to_not change(question, :title)
        expect { patch :update, params: { id: question, question: attributes_for(:invalid_question), format: :js } }.to_not change(question, :body)
      end

      it "recieves the flash-message about no permission for this action" do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }

        expect(flash[:alert]).to eq "You are not authorized to access this page."
      end

      it 'renders questions/update view' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }

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

      # it 'redirects to questions/index view' do
      #   delete :destroy, params: { id: question }
      #   expect(response).to redirect_to questions_path
      # end
    end
  end
end
