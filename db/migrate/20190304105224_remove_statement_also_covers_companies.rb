class RemoveStatementAlsoCoversCompanies < ActiveRecord::Migration[5.2]
  def change
    remove_column :statements, :also_covers_companies, type: :string
  end
end
