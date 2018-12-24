class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[destroy email_unsubscribe]

  authorize_resource

  def create
    @subscription = Subscription.new(user: current_user, question_id: params[:question_id])
    if @subscription.save
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
  def set_subscription
    @subscription = Subscription.find(params[:id])
  end
end
