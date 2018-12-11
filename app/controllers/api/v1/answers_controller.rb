class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[show]

  # def index
  #   @answers = @question.answers.best_first
  #   respond_with @answers
  # end

  def show
    respond_with @answer, serializer: DetailedAnswerSerializer
  end

  private
  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
