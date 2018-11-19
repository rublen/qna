class QuestionsController < ApplicationController
  include PublicActions

  before_action :set_question, only: %i[show update destroy]
  before_action :set_answer, only: %i[show]
  after_action :publish_to_stream, only: %i[create]

  def index
    respond_with(@questions = Question.all)
  end

  def new
    @question = Question.new
    @attachment = @question.attachments.new
    respond_with(@question)
  end

  def show
    gon.question_id = @question.id
    gon.question_author_id = @question.author.id
    @answers = @question.answers.best_first
    respond_with(@question)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  # не respond-ила, потому что 1) flash.now, 2) подключила CollectionResponder для create, для update не нужно
  def update
    if current_user.author_of? @question
      flash.now[:notice] = 'Your question was successfully updated' if @question.update(question_params)
    else
      flash.now[:alert] = 'This action is permitted only for author.'
    end
  end

  def destroy
    if current_user.author_of? @question
      respond_with(@question.destroy)
    else
      flash[:alert] = 'This action is permitted only for author.'
    end
  end

  private
  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :_destroy])
  end

  def set_answer
    @answer = @question.answers.new
  end

  def publish_to_stream
    return if @question.errors.any?
    ActionCable.server.broadcast('questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end
end
