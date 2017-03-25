class AddCountryIdToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :country_id, :integer
  end
end
