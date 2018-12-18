require 'rails_helper'

describe 'Profile API' do

  describe "GET /me" do
    let(:me) { create :user }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json, **options }
    end

    it_behaves_like "API Authorizable"

    before { do_request(access_token: access_token.token) }
    subject { response.body }

    %w(id email updated_at created_at admin).each do |attr|
      it { should be_json_eql(me.send(attr.to_sym).to_json).at_path(attr) }
    end

    %w(password encrypted_password).each do |attr|
      it { should_not have_json_path(attr) }
    end
  end


  describe "GET /index" do
    let(:users) { create_list :user, 3 }
    let(:me) { users[0] }
    let!(:access_token) { create(:access_token, resource_owner_id: me.id) }

    def do_request(options = {})
      get '/api/v1/profiles', params: { format: :json, **options }
    end

    it_behaves_like "API Authorizable"

    before { do_request(access_token: access_token.token) }
    subject { response.body }

    it { should have_json_size(2) }

    %w(id email updated_at created_at admin).each do |attr|
      it { should be_json_eql(users[1].send(attr.to_sym).to_json).at_path("#{0}/#{attr}") }
    end

    %w(password encrypted_password).each do |attr|
      it { should_not have_json_path("0/#{attr}") }
    end
  end
end
