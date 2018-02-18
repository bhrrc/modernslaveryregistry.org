class AddAlsoCoversCompaniesToStatements < ActiveRecord::Migration[5.0]
  def change
    add_column :statements, :also_covers_companies, :string
  end
end
