class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true
      t.references :user
      t.integer :voted, null: false
      t.index [:votable_type, :votable_id, :user_id], unique: true

      t.timestamps
    end
  end
end
