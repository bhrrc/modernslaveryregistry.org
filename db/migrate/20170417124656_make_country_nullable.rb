class MakeCountryNullable < ActiveRecord::Migration[5.0]
  def change
    change_column_null :companies, :country_id, true
  end
end
