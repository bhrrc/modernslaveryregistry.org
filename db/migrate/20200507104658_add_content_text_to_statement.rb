class AddContentTextToStatement < ActiveRecord::Migration[5.2]
  def change
    add_column :statements, :content_extracted, :boolean, default: false
    add_column :statements, :content_text, :text
  end
end
