class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show edit update destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def show
    @answer = @question.answers.new
  end

  def edit
    return unless current_user_author?
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question was successfully created'
    else
      render :new
    end
  end

  def update
    return unless current_user_author?

    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    return unless current_user_author?
    @question.destroy
    redirect_to questions_path, notice: 'Question was deleted successfully.'
  end

  private
  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def current_user_author?
    @question.author == current_user
  end
end
