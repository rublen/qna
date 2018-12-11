require 'rails_helper'

describe 'Questions API' do
  describe "GET /index" do

    context "unauthorized" do
      it "returns 401 status if there is no access_token" do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it "returns 401 status if access_token is invalid" do
        get '/api/v1/questions', params: { format: :json, access_token: '123456' }
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      let(:me) { create :user }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      let(:questions) { create_list :question, 2 }
      let(:question) { questions.first }

      let!(:comments) { create_list :comment, 2, commentable: question }
      let!(:attachments) { create_list :attachment, 2, attachable: question }
      let!(:answers) { create_list :answer, 2, question: question }

      before { sign_in me }

      describe 'GET index' do
        before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

        it "returns status 200" do
          expect(response).to be_successful
        end

        it "returns list of questions" do
          expect(response.body).to have_json_size(2)
        end

        %w(id title body updated_at created_at).each do |attr|
          it "question object contains #{attr}" do
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
          end
        end

        it "contains short_title" do
          expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("0/short_title")
        end
      end

      describe 'GET /show' do
        before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

        it "returns status 200" do
          expect(response).to be_successful
        end

        %w(id title body updated_at created_at).each do |attr|
          it "question object contains #{attr}" do
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr)
          end
        end

        context 'answers' do
          it "included in question object" do
            expect(response.body).to have_json_size(2).at_path("answers")
          end

          %w(id body updated_at created_at).each do |attr|
            it "contains #{attr}" do
              expect(response.body).to be_json_eql(answers[0].send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
            end
          end

          it "contains comments" do
          expect(response.body).to be_json_eql(answers[0].comments.count.to_json).at_path("answers/0/comments")
        end
        end

        context 'comments' do
          it "included in question object" do
            expect(response.body).to have_json_size(2).at_path("comments")
          end

          %w(id body created_at).each do |attr|
            it "contains #{attr}" do
              expect(response.body).to be_json_eql(comments[1].send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
            end
          end
        end

        context 'attachments' do
          it "included in answer object" do
            expect(response.body).to have_json_size(2).at_path("attachments")
          end

          it "contains file's url" do
            expect(response.body).to be_json_eql(attachments[1].file.url.to_json).at_path("attachments/0/url")
          end
        end
      end
    end
  end
end
