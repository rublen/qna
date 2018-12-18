class SubscrioptionsController < ApplicationController
  before_action :set_subscription

  authorize_resource

  def create
    @subscription = Subscription.new(user: current_user, question: current_question)
    if @subscription.create
      flash.now[:notice] = "You are subscribed to created question. You can unsubscribe through link in email."
    else
      flash.now[:alert] = "Subscription wasn't created."
    end
  end

  def destroy
    flash.now[:notice] = 'Subscription was deleted successfully.' if @subscription.destroy
  end

  private

  def current_question
    Question.find(params[:question_id])
  end

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end
end
