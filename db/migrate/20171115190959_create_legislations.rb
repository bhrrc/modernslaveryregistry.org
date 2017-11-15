class CreateLegislations < ActiveRecord::Migration[5.0]
  def change
    create_table :legislations do |t|
      t.string :name, null: false
      t.string :icon, null: false

      t.timestamps
    end
  end
end
