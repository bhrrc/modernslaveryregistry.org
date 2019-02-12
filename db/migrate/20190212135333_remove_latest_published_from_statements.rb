class RemoveLatestPublishedFromStatements < ActiveRecord::Migration[5.2]
  def change
    remove_column :statements, :latest_published, :boolean
  end
end
