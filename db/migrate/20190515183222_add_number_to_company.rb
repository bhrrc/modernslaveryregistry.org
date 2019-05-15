class AddNumberToCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :company_number, :string
  end
end
