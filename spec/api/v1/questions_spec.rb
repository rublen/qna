require 'rails_helper'

describe 'Questions API' do
  let(:access_token) { create(:access_token) }
  let(:questions) { create_list :question, 2 }
  let(:question) { questions.first }
  let!(:comments) { create_list :comment, 1, commentable: question }
  let!(:attachments) { create_list :attachment, 2, attachable: question }
  let!(:answers) { create_list :answer, 2, question: question }

  describe "GET /index" do
    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json, **options }
    end

    it_behaves_like "API Authorizable"

    before { do_request(access_token: access_token.token) }
    subject { response.body }

    it { should have_json_size 2 }
    it { should be_json_eql(question.title.truncate(10).to_json).at_path("0/short_title") }

    %w(id title body updated_at created_at).each do |attr|
      it { should be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}") }
    end
  end

  describe 'GET /show' do
    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json, **options }
    end

    it_behaves_like "API Authorizable"

    before { do_request(access_token: access_token.token) }
    subject { response.body }

    %w(id title body updated_at created_at).each do |attr|
      it { should be_json_eql(question.send(attr.to_sym).to_json).at_path(attr) }
    end

    context 'Answers' do
      it { should have_json_size(2).at_path("answers") }
      it { should be_json_eql(answers[0].comments.count.to_json).at_path("answers/0/comments") }
      %w(id body updated_at created_at).each do |attr|
        it { should be_json_eql(answers[0].send(attr.to_sym).to_json).at_path("answers/0/#{attr}") }
      end
    end

    context 'Comments' do
      it { should have_json_size(1).at_path("comments") }
      %w(id body created_at).each do |attr|
        it { should be_json_eql(comments[0].send(attr.to_sym).to_json).at_path("comments/0/#{attr}") }
      end
    end

    context 'Attachments' do
      it { should have_json_size(2).at_path("attachments") }
      it { should be_json_eql(attachments[1].file.url.to_json).at_path("attachments/0/url") }
    end
  end

  describe 'POST /create' do
    def do_request(options = {})
      post "/api/v1/questions", params: { title: "API title", body: "API body", format: :json, **options }
    end

    it_behaves_like "API Authorizable"

    before { do_request(access_token: access_token.token) }

    it "returns status :created and location header with new question url" do
      expect(response).to have_http_status :created
      expect(response.headers['Location']).to eq api_v1_question_url(Question.last)
    end

    it "returns json with new question" do
      expect(response.body).to be_json_eql("API title".to_json).at_path("title")
      expect(response.body).to be_json_eql("API body".to_json).at_path("body")
      expect(response.body).to be_json_eql(Question.last.id.to_json).at_path("id")
    end

    it 'with valid attributes creates a new question' do
      expect { do_request(access_token: access_token.token) }.to change(Question, :count).by(1)
    end

    it 'with invalid attributes does not creates a new question and returns status 422' do
      do_request(title: "", access_token: access_token.token)
      expect(response.status).to eq 422
    end
  end
end
