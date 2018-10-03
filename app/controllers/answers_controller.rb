class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[update best destroy]
  before_action :set_question, only: %i[create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    if @answer.save!
      flash.now[:notice] = 'Answer was created successfully.'
    end
  end

  def update
    if @answer.update(answer_params)
      flash.now[:notice] = 'Answer was updated successfully.'
    end
    @question = @answer.question
  end

  def best
    @question = @answer.question

    if current_user.author_of?(@question)
      @answer.mark_the_best
      @answers = Question.best_is_first_answers_list(@question)
    else
      flash.now[:alert] = 'This action is permitted only for author.'
    end
  end

  def destroy
    if current_user.author_of? @answer
      flash.now[:notice] = 'Answer was deleted successfully.' if @answer.destroy
    else
      flash.now[:alert] = 'This action is permitted only for author.'
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
    params.require(:answer).permit(:body, :best)
  end
end
