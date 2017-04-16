class AddPublishedToStatement < ActiveRecord::Migration[5.0]
  def change
    add_column :statements, :published, :boolean
    add_index :statements, :published
  end
end
