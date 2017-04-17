class AddContributedByIdToStatement < ActiveRecord::Migration[5.0]
  def change
    add_column :statements, :contributed_by_id, :integer
    add_index :statements, :contributed_by_id
    add_foreign_key :statements, :users, column: :contributed_by_id
  end
end
