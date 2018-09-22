class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[destroy]
  before_action :set_question, only: %i[create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to question_path(@question), notice: "Your answer published successfully."
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of? @answer
      @answer.destroy
      flash[:notice] = 'Answer was deleted successfully.'
    else
      flash[:alert] = 'This action is permitted only for author.'
    end

    redirect_to question_path(@answer.question)
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
end
