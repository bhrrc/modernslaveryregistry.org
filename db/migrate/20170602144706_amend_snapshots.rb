class AmendSnapshots < ActiveRecord::Migration[5.0]
  def change
    remove_column :snapshots, :content_length, :integer
    add_column :snapshots, :image_content_type, :string
    add_column :snapshots, :image_content_data, :binary
  end
end
