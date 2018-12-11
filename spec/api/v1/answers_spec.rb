require 'rails_helper'

describe 'Answers API' do
  let(:question) { create :question }
  let!(:answer) { create :answer, question: question }
  let!(:comments) { create_list :comment, 2, commentable: answer }
  let!(:attachments) { create_list :attachment, 2, attachable: answer }

  describe "GET /show" do
    context "unauthorized" do
      it "returns 401 status if there is no access_token" do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it "returns 401 status if access_token is invalid" do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: '123456' }
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      let(:me) { create :user }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        sign_in me
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token }
      end

      it "returns status 200" do
        expect(response).to be_successful
      end

      %w(id body updated_at created_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      context 'comments' do
        it "included in answer object" do
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
