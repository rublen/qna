require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  before_action :authenticate_user!
  before_action :gon_current_user, unless: :devise_controller?

  private
  def gon_current_user
    gon.current_user_id = current_user.id if current_user
  end

  def other_user
    User.find_by(email: 'other_user@mail.com')
  end
end
