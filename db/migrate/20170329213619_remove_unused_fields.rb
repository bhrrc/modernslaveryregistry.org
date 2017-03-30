class RemoveUnusedFields < ActiveRecord::Migration[5.0]
  def change
    remove_column :statements, :linked_from, :string
    remove_column :companies, :url, :string
  end
end
