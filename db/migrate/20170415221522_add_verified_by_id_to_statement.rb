class AddVerifiedByIdToStatement < ActiveRecord::Migration[5.0]
  def change
    add_column :statements, :verified_by_id, :integer
    add_index :statements, :verified_by_id
    add_foreign_key :statements, :users, column: :verified_by_id
  end
end
