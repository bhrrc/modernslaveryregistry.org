class RenameIndustriesIndustryNameToName < ActiveRecord::Migration[5.0]
  def change
    rename_column :industries, :industry_name, :name
  end
end
