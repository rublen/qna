class AnswersController < ApplicationController
  before_action :set_answer, only: %i[update destroy best]
  before_action :set_question, only: %i[create]
  before_action :set_answers, only: %i[destroy best]
  after_action :publish_answer, only: %[create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    @attachments = @answer.attachments

    if @answer.save
      flash.now[:notice] = 'Answer was created successfully.'
    end
  end

  def update
    if current_user.author_of? @answer
      @question = @answer.question
      flash.now[:notice] = 'Answer was updated successfully.' if @answer.update(answer_params)
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
    @answers = @answer.question.answers.best_first
  end

  def answer_params
    params.require(:answer).permit(:body, :best, attachments_attributes: [:file, :_destroy])
  end

  def publish_answer
    ActionCable.server.broadcast("question-#{@question.id}", {
      answer: @answer,
      attachments: @answer.attachments
    }.to_json)
  end
end
