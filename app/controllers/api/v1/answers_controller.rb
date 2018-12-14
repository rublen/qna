class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[show]

  authorize_resource

  def show
    respond_with @answer, serializer: DetailedAnswerSerializer
  end

  def create
    answer = @question.answers.new(answer_params)
    answer.user_id = current_resource_owner.id
    if answer.save
      render json: answer, location: api_v1_answer_url(answer), status: :created
    else
      head :unprocessable_entity
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
    params.permit(:body)
  end
end
