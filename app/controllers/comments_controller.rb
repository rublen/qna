class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]
  before_action :set_commentable, only: %i[create]

  authorize_resource

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.author = current_user
    @comment.save
    publish_to_stream
  end

  def destroy
    flash.now[:notice] = 'Comment was deleted successfully.' if @comment.destroy
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

  def publish_to_stream
    ActionCable.server.broadcast("question-#{question_id}", { comment:
      { id: @comment.id,
        body: @comment.body,
        user_email: @comment.author.email,
        user_id: @comment.user_id,
        created_at: @comment.created_at.strftime('%F %T'),
        commentable_css_id: "##{@comment.commentable_type.underscore}-#{@commentable.id}" }
    }.to_json) if @comment
  end

  def question_id
    @comment.commentable_type == 'Question' ? @commentable.id : @commentable.question.id
  end
end
