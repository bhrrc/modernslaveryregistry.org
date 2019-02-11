class RemoveCompanyIdFromStatements < ActiveRecord::Migration[5.2]
  def change
    remove_column :statements, :company_id, :integer
  end
end
