class PopulateCompanyStatementTable < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
    insert into companies_statements
    select company_id,
           id as statement_id
    from statements
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
