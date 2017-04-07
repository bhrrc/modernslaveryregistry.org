class AddCountryLatLng < ActiveRecord::Migration[5.0]
  def change
    add_column :countries, :lat, :float
    add_column :countries, :lng, :float
  end
end
