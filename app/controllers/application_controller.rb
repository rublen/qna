require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  before_action :authenticate_user!
  before_action :gon_current_user, unless: :devise_controller?

  check_authorization only: [Answer, Question, Comment, Attachment, Vote, Subscription]

  rescue_from CanCan::AccessDenied do |e|
    flash.now[:alert] = e.message
    render action_name if lookup_context.exists?("#{controller_name}/#{action_name}")
  end

  private
  def gon_current_user
    gon.current_user_id = current_user.id if current_user
  end
end
