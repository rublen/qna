require 'rails_helper'

RSpec.shared_examples_for "voted", type: :request do
  sign_in_user

  let(:model) { described_class.controller_name.singularize.underscore }
  let(:votable) { create(model.to_sym) }
  let(:vote) { create(:vote, user: @user)}

  let(:upvote_path) { polymorphic_path([:up, votable, Vote]) }
  let(:downvote_path) { polymorphic_path([:down, votable, Vote]) }
  let(:unvote_path) { unvote_vote_path(vote) }

  let(:upvote_attrs) { attributes_for(:"#{model}_vote", user_id: @user.id) }
  let(:downvote_attrs) { attributes_for(:"#{model}_vote", user_id: @user.id, upvoted: false) }


  describe "POST #up for votes" do
    it 'creates a new vote in association with votable' do
      expect { post upvote_path, params: { vote: upvote_attrs, format: :json } }.to change(votable.votes, :count).by(1)
    end

    it "don't allow for the author of votable to vote for it" do
      sign_in(votable.author)
      expect { post upvote_path, params: { vote: attributes_for(:"#{model}_vote", user_id: votable.author.id) } }.to_not change(Vote, :count)
    end

    it 'sets voted value 1 for new vote' do
      post upvote_path, params: { vote: upvote_attrs, format: :json }
      expect(Vote.last.voted).to eq 1
    end

    it 'renders json data with valid attributes' do
      post upvote_path, params: { vote: upvote_attrs, format: :json }
      votable.reload

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["vote_id"]).to eq(Vote.last.id)
      expect(JSON.parse(response.body)["votable_sum"]).to eq votable.vote_sum
      expect(JSON.parse(response.body)["up_voted"]).to eq votable.upvoted?(@user)
      expect(JSON.parse(response.body)["down_voted"]).to eq votable.downvoted?(@user)
    end

    it 'renders json data errors (invalid attributes)' do
      post upvote_path, params: { :vote => attributes_for(:"#{model}_invalid_vote"), format: :json }

      expect(response.status).to eq(422) # status 200, не могу придумать, как протестировать этот случай
      expect(JSON.parse(response.body)["error"]).to eq("User must exist")
    end
  end


  describe "POST #down for votes" do
    it 'creates a new vote in association with votable' do
      expect { post downvote_path, params: { vote: downvote_attrs, format: :json } }.to change(votable.votes, :count).by(1)
    end

    it "don't allow for the author of votable to vote for it" do
      sign_in(votable.author)
      expect { post downvote_path, params: { vote: attributes_for(:"#{model}_vote", user_id: votable.author.id, upvoted: false) } }.to_not change(Vote, :count)
    end

    it 'sets new vote with voted value -1' do
      post downvote_path, params: { vote: downvote_attrs, format: :json }
      expect(Vote.last.voted).to eq -1
    end

    it 'renders json data with valid attributes' do
      post downvote_path, params: { vote: downvote_attrs, format: :json }
      votable.reload

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["vote_id"]).to eq(Vote.last.id)
      expect(JSON.parse(response.body)["votable_sum"]).to eq votable.vote_sum
      expect(JSON.parse(response.body)["up_voted"]).to eq votable.upvoted?(@user)
      expect(JSON.parse(response.body)["down_voted"]).to eq votable.downvoted?(@user)
    end

    it 'renders json data errors (invalid attributes)' do
      post downvote_path, params: { :vote => attributes_for(:"#{model}_invalid_vote", upoted: false), format: :json }

      expect(response.status).to eq(422) # status 200, не могу протестировать
      expect(JSON.parse(response.body)["error"]).to eq("User must exist")
    end
  end


  describe "DELETE #unvote for votes" do
    before { sign_in(vote.user) }

    it 'deletes vote from the DB' do
      expect { delete unvote_path, params: { vote_id: vote.id, format: :json } }.to change(Vote, :count).by(-1)
    end

    it "don't allow to delete the vote if user is not vote's author" do
      sign_in(create(:user))
      expect { delete unvote_path, params: { vote_id: vote.id } }.to_not change(Vote, :count)
    end

    it 'renders json data if deleting was success' do
      post upvote_path, params: { vote: upvote_attrs, format: :json }
      votable.reload

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["vote_id"]).to eq(Vote.last.id)
      expect(JSON.parse(response.body)["votable_sum"]).to eq votable.vote_sum
      expect(JSON.parse(response.body)["up_voted"]).to eq votable.upvoted?(@user)
      expect(JSON.parse(response.body)["down_voted"]).to eq votable.downvoted?(@user)
    end

    it 'renders json data errors' do
      post upvote_path, params: { :vote => attributes_for(:"#{model}_invalid_vote"), format: :json }

      expect(response.status).to eq(422) # status 200, не могу протестировать
      expect(JSON.parse(response.body)["error"]).to eq("User must exist")
    end
  end
end
