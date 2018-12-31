class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true
      t.references :question
      t.index [:user_id, :question_id], unique: true

      t.timestamps
    end
  end
end
