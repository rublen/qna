class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json

  def me
    respond_with current_resource_owner
  end

  def others
    profiles = User.where.not(id: doorkeeper_token.resource_owner_id)
    respond_with profiles
  end

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
