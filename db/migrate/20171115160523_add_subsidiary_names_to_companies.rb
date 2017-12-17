class AddSubsidiaryNamesToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :subsidiary_names, :string
  end
end
