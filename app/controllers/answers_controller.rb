class AnswersController < ApplicationController
  before_action :set_answer, only: %i[show]
  before_action :set_question, only: %i[new create]

  def new
    @answer = @question.answers.new
  end

  def show
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to question_path(@question),
             notice: "Your answer published successfully"
    else
      render template: 'questions/show',
             question: @question,
             notice: "Smth went wrong. Try again"
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
