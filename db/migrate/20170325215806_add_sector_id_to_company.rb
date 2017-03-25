class AddSectorIdToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :sector_id, :integer
  end
end
