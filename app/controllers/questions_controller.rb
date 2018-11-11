class QuestionsController < ApplicationController
  include PublicActions

  before_action :set_question, only: %i[show update destroy]
  after_action :publish_question, only: %i[create]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @attachment = @question.attachments.new
  end

  def show
    gon.question_id = @question.id
    gon.question_author_id = @question.author.id

    @answer = @question.answers.new
    @answer.attachments.new
    @answer.votes.new
    @answers = @question.answers.best_first
    @attachments = @question.attachments
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to questions_path, notice: 'Your question was successfully created'
    else
      render 'new'
    end
  end

  def update
    if current_user.author_of? @question
      flash.now[:notice] = 'Your question was successfully updated' if @question.update(question_params)
    else
      flash.now[:alert] = 'This action is permitted only for author.'
    end
  end

  def destroy
    if current_user.author_of? @question
      @question.destroy
      flash[:notice] = 'Question was deleted successfully.'
    else
      flash[:alert] = 'This action is permitted only for author.'
    end

    redirect_to questions_path
  end

  private
  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :_destroy])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end
end
