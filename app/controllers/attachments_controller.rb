class AttachmentsController < ApplicationController
  authorize_resource

  def destroy
    @attachment = Attachment.find(params[:id])
    # authorize! :destroy, @attachment, attachable: current_user
    # if current_user.author_of? @attachment.attachable
      flash.now[:notice] = 'Attachment was deleted successfully.' if @attachment.destroy
    # else
    #   flash.now[:alert] = 'This action is permitted only for author.'
    # end
  end
end
