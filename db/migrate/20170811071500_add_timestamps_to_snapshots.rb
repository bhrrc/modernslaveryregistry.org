class AddTimestampsToSnapshots < ActiveRecord::Migration[5.0]
  def change
    add_timestamps :snapshots, default: Time.zone.now
    change_column_default :snapshots, :created_at, nil
    change_column_default :snapshots, :updated_at, nil
  end
end
