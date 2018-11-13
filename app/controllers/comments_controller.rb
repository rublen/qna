class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]
  before_action :set_commentable, only: %i[create]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  def destroy
     if current_user.author_of? @comment
      flash.now[:notice] = 'Comment was deleted successfully.' if @comment.destroy
    else
      flash.now[:alert] = 'This action is permitted only for author.'
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_commentable
    klass = [Question, Answer].detect{|c| params["#{c.name.underscore}_id"]}
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
