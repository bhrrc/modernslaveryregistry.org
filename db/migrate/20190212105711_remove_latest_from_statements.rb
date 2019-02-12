class RemoveLatestFromStatements < ActiveRecord::Migration[5.2]
  def change
    remove_column :statements, :latest, :boolean
  end
end
