class AddQuestionToAttachments < ActiveRecord::Migration[5.2]
  def change
    add_reference :attachments, :question, foreign_key: true
  end
end
