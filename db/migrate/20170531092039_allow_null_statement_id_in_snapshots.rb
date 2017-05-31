class AllowNullStatementIdInSnapshots < ActiveRecord::Migration[5.0]
  def change
    change_column :snapshots, :statement_id, :integer, null: true
  end
end
