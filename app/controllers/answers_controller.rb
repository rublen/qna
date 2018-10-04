class AnswersController < ApplicationController
  protect_from_forgery except: :best
  before_action :authenticate_user!
  before_action :set_answer, only: %i[update destroy best]
  before_action :set_question, only: %i[create]
  before_action :set_answers, only: %i[destroy best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    if @answer.save
      flash.now[:notice] = 'Answer was created successfully.'
    end
  end

  def update
    if @answer.update(answer_params)
      flash.now[:notice] = 'Answer was updated successfully.'
    end
    @question = @answer.question
  end

  def destroy
    if current_user.author_of? @answer
      flash.now[:notice] = 'Answer was deleted successfully.' if @answer.destroy

    else
      flash.now[:alert] = 'This action is permitted only for author.'
    end
  end

  def best
    @question = @answer.question

    if current_user.author_of?(@question)
      @answer.mark_the_best
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

  def set_answers
    @answers = Question.best_is_first_answers_list(@answer.question)
  end

  def answer_params
    params.require(:answer).permit(:body, :best)
  end
end
