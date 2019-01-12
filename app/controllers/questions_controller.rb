class QuestionsController < ApplicationController
  include PublicActions

  before_action :set_question, only: %i[show update destroy]
  before_action :set_answer, only: %i[show]
  after_action :publish_to_stream, only: %i[create]

  authorize_resource
  skip_authorization_check only: %i[index show]

  def index
    @pagy, @questions = pagy_array(questions, items: 20)
    respond_with(@questions)
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

  def update
    flash.now[:notice] = 'Your question was successfully updated' if @question.update(question_params)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private
  def questions
    @questions = if params[:question_search]
      Question.search(params[:question_search], limit: 500)
    else
      Question.all
    end
  end

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
