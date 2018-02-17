class AddIncludeInComplianceStatsToLegislations < ActiveRecord::Migration[5.0]
  def change
    add_column :legislations, :include_in_compliance_stats, :boolean, null: false, default: false
  end
end
