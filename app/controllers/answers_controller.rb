class AnswersController < ApplicationController
  before_action :set_answer, only: %i[update destroy best]
  before_action :set_question, only: %i[create]
  before_action :set_answers, only: %i[destroy best]
  # after_action :publish_to_stream, only: %[create]

  authorize_resource

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    @attachments = @answer.attachments

    if @answer.save
      flash.now[:notice] = 'Answer was created successfully.'
      publish_to_stream
    end
  end

  def update
    @question = @answer.question
    flash.now[:notice] = 'Answer was updated successfully.' if @answer.update(answer_params)
  end

  def destroy
    flash.now[:notice] = 'Answer was deleted successfully.' if @answer.destroy
  end

  def best
    @question = @answer.question
    @answer.mark_the_best
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

  def publish_to_stream
    ActionCable.server.broadcast("question-#{@question.id}", {
      answer: @answer,
      answered_by: "#{@answer.author.email}, #{@answer.created_at.strftime('%F %T')}",
      attachments: @answer.attachments
    }.to_json)
  end
end
