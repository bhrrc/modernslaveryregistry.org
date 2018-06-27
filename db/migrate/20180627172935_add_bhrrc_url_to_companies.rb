class AddBhrrcUrlToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :bhrrc_url, :string
  end
end
