class SetDefaultIncludeInComplianceStats < ActiveRecord::Migration[5.0]
  def up
    Legislation.where(name: 'UK Modern Slavery Act').update_all(
      include_in_compliance_stats: true
    )
  end
end
