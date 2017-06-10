class AddLatestAndLatestPublishedToStatements < ActiveRecord::Migration[5.0]
  def change
    add_column :statements, :latest, :boolean, default: false
    add_column :statements, :latest_published, :boolean, default: false
    add_index :statements, :latest, where: :latest
    add_index :statements, :latest_published, where: :latest_published
  end
end
