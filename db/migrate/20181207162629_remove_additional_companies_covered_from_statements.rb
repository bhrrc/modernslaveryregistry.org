class RemoveAdditionalCompaniesCoveredFromStatements < ActiveRecord::Migration[5.2]
  def change
    remove_column :statements, :additional_companies_covered, :integer, default: 0
  end
end
