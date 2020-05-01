class AddHomeOfficeAuditToStatement < ActiveRecord::Migration[5.2]
  def change
    add_column :statements, :home_office_audit, :boolean, default: false
  end
end
