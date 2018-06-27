class RemoveSnapshotAttachmentsFromDatabase < ActiveRecord::Migration[5.2]
  def change
    remove_column :snapshots, :content_data
    remove_column :snapshots, :content_type
    remove_column :snapshots, :image_content_data
    remove_column :snapshots, :image_content_type
  end
end
