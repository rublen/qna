class Api::V1::AnswersController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, only: %[create]

  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[show]

  def show
    respond_with @answer, serializer: DetailedAnswerSerializer
  end

  def create
    authorize!(:create, Answer)
    answer = @question.answers.new(answer_params)
    answer.user_id = current_resource_owner.id
    if answer.save
      head :created, location: api_v1_answer_url(answer)
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
