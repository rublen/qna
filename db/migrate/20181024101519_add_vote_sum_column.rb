class AddVoteSumColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :vote_sum, :integer, default: 0, null: false
    add_column :answers, :vote_sum, :integer, default: 0, null: false
  end
end
