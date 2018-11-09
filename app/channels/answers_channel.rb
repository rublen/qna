class AnswersChannel < ApplicationCable::Channel
  def subscribed
    p '**********************', params
    stream_from "question-#{params[:question_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
