class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[destroy email_unsubscribe]

  authorize_resource

  def create
    @subscription = Subscription.new(user: current_user, question: current_question)
    if @subscription.save
      flash.now[:notice] = "You are subscribed."
    else
      flash.now[:alert] = "Subscription wasn't created."
    end
  end

  def create_daily_subscription
    @subscription = Subscription.new(user: current_user)
    if @subscription.save!
      flash.now[:notice] = "You are subscribed."
    else
      flash.now[:alert] = "Subscription wasn't created."
    end
  end

  def email_unsubscribe; end

  def destroy
    if @subscription.destroy
      flash.now[:notice] = 'Unsubscribed.'
    end
  end

  private

  def current_question
    Question.find(params[:question_id])
  end

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end
end
