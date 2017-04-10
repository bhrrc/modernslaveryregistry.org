class AddBrokenUrlToStatements < ActiveRecord::Migration[5.0]
  def change
    add_column :statements, :broken_url, :boolean
  end
end
