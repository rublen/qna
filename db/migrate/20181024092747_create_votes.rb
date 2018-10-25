class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true, index: false
      t.references :user, index: false
      t.integer :voted, default: 0, null: false
      t.index [:votable_type, :votable_id, :user_id], unique: true

      t.timestamps
    end
  end
end
