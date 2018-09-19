class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[show destroy]
  before_action :set_question, only: %i[new create]

  def new
    @answer = @question.answers.new
  end

  def show
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to question_path(@question), notice: "Your answer published successfully."
    else
      render template: 'questions/show',
             question: @question,
             notice: "Smth went wrong. Try again"
    end
  end

  def destroy
    return unless current_user_author?
    @answer.destroy
    redirect_to question_path(@answer.question), notice: 'Answer was deleted successfully.'
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def current_user_author?
    current_user == @answer.author
  end
end
