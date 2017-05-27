class CreateSnapshots < ActiveRecord::Migration[5.0]
  def change
    create_table :snapshots do |t|
      t.binary :content_data, null: false
      t.string :content_type, null: false
      t.integer :content_length
      t.references :statement, null: false, foreign_key: true
    end
    remove_column :statements, :content_data, :binary
    remove_column :statements, :content_type, :string
    remove_column :statements, :content_length, :integer
  end
end
