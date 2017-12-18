class RemoveStatementsPeriodCovered < ActiveRecord::Migration[5.0]
  def change
    remove_column :statements, :period_covered, :string
  end
end
