class RemoveContributedByIdFromStatement < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :statements, column: :contributed_by_id
    remove_index :statements, :contributed_by_id
    remove_column :statements, :contributed_by_id, :integer

    add_column :statements, :contributor_email, :string
  end
end
