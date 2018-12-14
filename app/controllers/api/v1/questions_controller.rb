class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[show]

  authorize_resource

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    respond_with @question, serializer: DetailedQuestionSerializer
  end

  def create
    question = Question.new(question_params)
    question.user_id = current_resource_owner.id
    if question.save
      render json: question, location: api_v1_question_url(question), status: :created
    else
      head :unprocessable_entity
    end
  end

  private
  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.permit(:title, :body)
  end
end
