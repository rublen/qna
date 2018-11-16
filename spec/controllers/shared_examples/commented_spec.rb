require 'rails_helper'

RSpec.shared_examples_for "commented", type: :request do

  let(:user) { create :user }
  let(:model) { described_class.controller_name.singularize.underscore }
  let(:commentable) { create(model.to_sym) }
  let!(:comment) { create(:comment, commentable: commentable, user: user)}

  let(:create_comment_path) { polymorphic_path([commentable, Comment]) }

  context "Authenticated user" do
    before { sign_in user }
    describe "POST #create for comments" do
      it 'creates a new comment in association with commentable' do
        expect { post create_comment_path, params: { comment: attributes_for(:comment), format: :js } }.to change(commentable.comments, :count).by(1)
      end

      it 'renders comments/create js-view' do
        post create_comment_path, params: { comment: attributes_for(:comment), format: :js }
        expect(response).to render_template 'comments/create'
      end
    end

    describe "DELETE #destroy for comments" do
      it 'author of the comment deletes it from the DB' do
        expect { delete comment_path(comment), params: { comment_id: comment.id, format: :js } }.to change(Comment, :count).by(-1)
      end

      it "not author of the comment can't delete the comment" do
        sign_in(create(:user))
        expect { delete comment_path(comment), params: { comment_id: comment.id, format: :js  } }.to_not change(Comment, :count)
      end

      it 'renders comments/destroy js-view' do
        delete comment_path(comment), params: { comment_id: comment.id, format: :js  }
        expect(response).to render_template 'comments/destroy'
      end
    end
  end

  context "Non authenticated user" do
    describe "can not create a comment" do
      it "can't creates a new comment" do
        expect { post create_comment_path, params: { comment: attributes_for(:comment), format: :js } }.to_not change(Comment, :count)
      end

      it "can't delete the comment" do
        expect { delete comment_path(comment), params: { comment_id: comment.id } }.to_not change(Comment, :count)
      end
    end
  end
end
