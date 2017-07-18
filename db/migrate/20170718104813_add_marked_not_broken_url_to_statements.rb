class AddMarkedNotBrokenUrlToStatements < ActiveRecord::Migration[5.0]
  def change
    add_column :statements, :marked_not_broken_url, :boolean, default: false
  end
end
