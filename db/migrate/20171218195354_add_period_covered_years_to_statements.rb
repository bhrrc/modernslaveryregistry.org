class AddPeriodCoveredYearsToStatements < ActiveRecord::Migration[5.0]
  def change
    add_column :statements, :first_year_covered, :integer
    add_column :statements, :last_year_covered, :integer
  end
end
