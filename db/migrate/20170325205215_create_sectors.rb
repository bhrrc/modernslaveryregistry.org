class CreateSectors < ActiveRecord::Migration[5.0]
  def change
    create_table :sectors do |t|
      t.string :name

      t.timestamps
    end
    add_index :sectors, :name, unique: true
  end
end
