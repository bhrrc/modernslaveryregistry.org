class AddIndices < ActiveRecord::Migration[5.0]
  def change
    add_index :companies, :country_id
    add_index :companies, :sector_id
    add_index :statements, :company_id
  end
end
