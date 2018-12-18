require 'rails_helper'

describe 'Answers API' do
  let(:access_token) { create(:access_token) }
  let(:question) { create :question }
  let!(:answer) { create :answer, question: question }
  let!(:comments) { create_list :comment, 2, commentable: answer }
  let!(:attachments) { create_list :attachment, 2, attachable: answer }

  describe "GET /show" do
    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json, **options }
    end

    it_behaves_like "API Authorizable"

    before { do_request(access_token: access_token.token) }
    subject { response.body }

    %w(id body updated_at created_at).each do |attr|
      it { should be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr) }
    end

    context 'comments' do
      it { should have_json_size(2).at_path("comments") }
      %w(id body created_at).each do |attr|
        it { should be_json_eql(comments[1].send(attr.to_sym).to_json).at_path("comments/0/#{attr}") }
      end
    end

    context 'attachments' do
      it { should have_json_size(2).at_path("attachments") }
      it { should be_json_eql(attachments[1].file.url.to_json).at_path("attachments/0/url") }
    end
  end

  describe 'POST /create' do
    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { body: "API body", format: :json, **options }
    end

    it_behaves_like "API Authorizable"

    before { do_request(access_token: access_token.token) }

    it "returns status :created and location header with new answer url" do
      expect(response).to have_http_status :created
      expect(response.headers['Location']).to eq api_v1_answer_url(Answer.last)
    end

    it "returns json with new answer" do
      expect(response.body).to be_json_eql("API body".to_json).at_path("body")
      expect(response.body).to be_json_eql(Answer.last.id.to_json).at_path("id")
    end

    it 'with valid params creates a new answer' do
      expect { do_request(access_token: access_token.token) }.to change(Answer, :count).by(1)
    end

    it 'with invalid params does not creates a new answer and returns status 422' do
      expect { do_request(body: "", access_token: access_token.token) }.to_not change(Answer, :count)
      expect(response.status).to eq 422
    end
  end
end
