class AddPeriodCoveredToStatements < ActiveRecord::Migration[5.0]
  def change
    add_column :statements, :period_covered, :string, default: ''
  end
end
