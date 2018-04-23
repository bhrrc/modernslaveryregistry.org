class CreateIndustries < ActiveRecord::Migration[5.0]
  def change
    create_table :industries do |t|
      t.string :sector_name
      t.integer :sector_code
      t.string :industry_group_name
      t.integer :industry_group_code
      t.string :industry_name
      t.integer :industry_code
    end
  end
end
