class TruncateCompaniesStatementsJoinTable < ActiveRecord::Migration[5.2]
  def up
    truncate :companies_statements
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
