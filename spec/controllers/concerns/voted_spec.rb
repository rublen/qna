require 'rails_helper'

RSpec.shared_examples_for "voted", type: :request do
  sign_in_user

  let(:model) { described_class.controller_name.singularize.underscore }
  let(:votable) { create(model.to_sym) }
  let(:path) { polymorphic_path([:up, votable, Vote]) }

  let(:upvote_attrs) { attributes_for(:"#{model}_vote", user_id: @user.id) }
  let(:downvote_attrs) { attributes_for(:"#{model}_vote", user_id: @user.id, upvoted: false) }


  describe "POST #up for votes" do

    it 'creates a new vote in association with votable' do
      expect { post path, params: { vote: upvote_attrs, format: :json } }.to change(votable.votes, :count).by(1)
    end

    it "the author of votable can't vote for it" do
      sign_in(votable.author)
      expect { post path, params: { vote: attributes_for(:"#{model}_vote", user_id: votable.author.id), format: :json } }.to_not change(Vote, :count)
    end

    it 'sets new vote with voted value 1' do
      post path, params: { vote: upvote_attrs, format: :json }
      expect(Vote.last.voted).to eq 1
    end

    it 'renders json data with valid attributes' do
      post path, params: { vote: upvote_attrs, format: :json }
      votable.reload

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["vote_id"]).to eq(Vote.last.id)
      expect(JSON.parse(response.body)["votable_sum"]).to eq votable.vote_sum
      expect(JSON.parse(response.body)["up_voted"]).to eq votable.upvoted?(@user)
      expect(JSON.parse(response.body)["down_voted"]).to eq votable.downvoted?(@user)
    end

    it 'renders json data errors with invalid attributes' do
      post path, params: { :vote => attributes_for(:"#{model}_invalid_vote"), format: :json }
      # p '---', @user, votable, Vote.last
      expect(response.status).to eq(422) # status 200, vote создается как обычно, **_invalid_vote не срабатывает, там user_id { nil }
      expect(JSON.parse(response.body)["error"]).to eq("User must exist")
    end
  end

  describe "POST #down for votes" do

    it 'creates a new vote in association with votable' do
      expect { post path, params: { vote: downvote_attrs, format: :json } }.to change(votable.votes, :count).by(1)
    end

    it "the author of votable can't vote for it" do
      sign_in(votable.author)
      expect { post path, params: { vote: attributes_for(:"#{model}_vote", user_id: votable.author.id, upvoted: false), format: :json } }.to_not change(Vote, :count)
    end

    it 'sets new vote with voted value -1' do
      post path, params: { vote: downvote_attrs, format: :json }
      p'@@@', Vote.last
      expect(Vote.last.voted).to eq -1
    end

    it 'renders json data with valid attributes' do
      post path, params: { vote: downvote_attrs, format: :json }
      votable.reload

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["vote_id"]).to eq(Vote.last.id)
      expect(JSON.parse(response.body)["votable_sum"]).to eq votable.vote_sum
      expect(JSON.parse(response.body)["up_voted"]).to eq votable.upvoted?(@user)
      expect(JSON.parse(response.body)["down_voted"]).to eq votable.downvoted?(@user)
    end

    it 'renders json data errors with invalid attributes' do
      post path, params: { :vote => attributes_for(:"#{model}_invalid_vote", upoted: false), format: :json }
      # p '---', @user, votable, Vote.last
      expect(response.status).to eq(422) # status 200, vote создается как обычно, **_invalid_vote не срабатывает, там user_id { nil }
      expect(JSON.parse(response.body)["error"]).to eq("User must exist")
    end
  end

  #   context 'with valid attributes' do
  #     it 'saves a new answer in the DB in assosiation with question' do
  #       expect {
  #         post :create, params: {
  #           answer: attributes_for(:answer),
  #           question_id: question,
  #           format: :js }
  #       }.to change(question.answers, :count).by(1)
  #     end

  #     it 'saves a new answer in the DB in assosiation with user' do
  #       expect {
  #         post :create, params: {
  #           answer: attributes_for(:answer),
  #           question_id: question,
  #           format: :js }
  #       }.to change(@user.answers, :count).by(1)
  #     end

  #     it 'renders answers/create view' do
  #       post :create, params: {
  #         answer: attributes_for(:answer),
  #         question_id: question,
  #         format: :js }

  #       expect(response).to render_template 'answers/create'
  #     end
  #   end

  #   context 'with invalid attributes' do
  #     it 'does not save a new answer in the DB' do
  #       expect { post :create, params: {
  #         answer: attributes_for(:invalid_answer),
  #         question_id: question,
  #         format: :js }
  #       }.to_not change(Answer, :count)
  #     end

  #     it 'renders answers/create view' do
  #       post :create, params: {
  #         answer: attributes_for(:invalid_answer),
  #         question_id: question,
  #         format: :js }

  #       expect(response).to render_template 'answers/create'
  #     end
  #   end
  # end
end
