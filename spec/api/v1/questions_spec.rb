require 'rails_helper'

describe 'Questions API' do
  let(:me) { create :user }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:questions) { create_list :question, 2 }
  let(:question) { questions.first }
  let!(:comments) { create_list :comment, 2, commentable: question }
  let!(:attachments) { create_list :attachment, 2, attachable: question }
  let!(:answers) { create_list :answer, 2, question: question }

  describe "GET /index" do
    context "Unauthorized" do
      it "returns 401 status if there is no access_token" do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it "returns 401 status if access_token is invalid" do
        get '/api/v1/questions', params: { format: :json, access_token: '123456' }
        expect(response.status).to eq 401
      end
    end

    context "Authorized" do
      before do
        sign_in me
        get '/api/v1/questions', params: { format: :json, access_token: access_token.token }
      end

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
  end

  describe 'GET /show' do
    context "Unauthorized" do
      it "returns 401 status if there is no access_token" do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it "returns 401 status if access_token is invalid" do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: '123456' }
        expect(response.status).to eq 401
      end
    end

    context "Authorized" do
      before do
        sign_in me
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token }
      end

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

  describe 'POST /create' do
    context "Unauthorized" do
      it "returns 401 status if there is no access_token" do
        post "/api/v1/questions", params: { title: "API title", body: "API body", format: :json }
        expect(response.status).to eq 401
      end

      it "returns 401 status if access_token is invalid" do
        post "/api/v1/questions", params: { title: "API title", body: "API body", access_token: "123456", format: :json  }
        expect(response.status).to eq 401
      end
    end

    context "Authorized" do
      before { sign_in me }

      it "returns status :created and location header with new question url" do
        post "/api/v1/questions", params: { title: "API title", body: "API body", access_token: access_token.token }
        expect(response).to have_http_status :created
        expect(response.headers['Location']).to eq api_v1_question_url(Question.last)
      end

      it 'with valid params creates a new question' do
        expect { post "/api/v1/questions", params: { title: "API title", body: "API body", access_token: access_token.token } }.to change(Question, :count).by(1)
      end

      it 'with invalid params does not creates a new question and returns status 422' do
        expect { post "/api/v1/questions", params: { title: "", body: "", access_token: access_token.token } }.to_not change(Question, :count)
        expect(response.status).to eq 422
      end
    end
  end
end
