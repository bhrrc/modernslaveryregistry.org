class AddOverrideUrlToStatements < ActiveRecord::Migration[5.2]
  def change
    add_column :statements, :override_url, :string, default: nil
  end
end
