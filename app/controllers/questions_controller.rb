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
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to questions_path, notice: 'Your question was successfully created'
    end
  end

  def update
    if current_user.author_of? @question
      # flash.now не работает
      flash.now[:notice] = 'Your question was successfully updated' if @question.update(question_params)
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
    params.require(:question).permit(:title, :body)
  end
end
