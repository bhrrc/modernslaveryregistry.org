class RenameCompanySubsidiaryNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :companies, :subsidiary_names, :related_companies
  end
end
