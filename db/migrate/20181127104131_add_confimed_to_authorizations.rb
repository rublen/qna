class AddConfimedToAuthorizations < ActiveRecord::Migration[5.2]
  def change
    add_column :authorizations, :confirmed, :boolean, null: false, default: true
  end
end
