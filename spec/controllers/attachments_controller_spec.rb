require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  describe 'DELETE #destroy' do
    context 'The author of question deletes the attachment' do
      let!(:question_attach) { create(:question_attach) }
      let(:question) { question_attach.attachable }
      let(:user) { question.author }

      before { sign_in user }

      it 'assigns requested attachment to @attachment' do
        delete :destroy, params: { id: question_attach, format: :js }
        expect(assigns(:attachment)).to eq question_attach
      end

      it 'deletes attacment for the question' do
        expect { delete :destroy, params: { id: question_attach, format: :js } }.to change(question.attachments, :count).by(-1)
      end

      it 'renders attachments/destroy js-view' do
        delete :destroy, params: { id: question_attach, format: :js }
        expect(response).to render_template 'destroy'
      end
    end


    context 'The author of answer deletes the attachment' do
      let!(:answer_attach) { create(:answer_attach) }
      let(:answer) { answer_attach.attachable }
      let(:user) { answer.author }

       before { sign_in user }

      it 'assigns requested attachment to @attachment' do
        delete :destroy, params: { id: answer_attach, format: :js }
        expect(assigns(:attachment)).to eq answer_attach
      end

      it 'deletes attacment for the answer' do
        expect { delete :destroy, params: { id: answer_attach, format: :js } }.to change(answer.attachments, :count).by(-1)
      end

      it 'renders attachments/destroy js-view' do
        delete :destroy, params: { id: answer_attach, format: :js }
        expect(response).to render_template 'destroy'
      end
    end


    context 'Not author of parent object can not delete the attachment' do
      sign_in_user
      let!(:attachment) { create(:attachment) }

      it 'assigns requested answer to @answer' do
        delete :destroy, params: { id: attachment, format: :js }
        expect(assigns(:attachment)).to eq attachment
      end

      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: attachment, format: :js } }.to_not change(Attachment, :count)
      end

      it 'renders attachments/destroy js-view' do
        delete :destroy, params: { id: attachment, format: :js }
        expect(response).to render_template 'destroy'
      end
    end
  end
end
