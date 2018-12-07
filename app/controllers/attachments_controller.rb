class AttachmentsController < ApplicationController
  before_action :set_attachment, only: :destroy

  authorize_resource

  def destroy
    flash.now[:notice] = 'Attachment was deleted successfully.' if @attachment.destroy
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end
end
