class PopulateStatementsCompanyIdField < ActiveRecord::Migration[5.2]
  def up
    # Fail fast if any statement is associated with multiple companies
    sql = "SELECT statement_id, COUNT(*) FROM companies_statements GROUP BY statement_id HAVING COUNT(*) > 1;"
    statements_belonging_to_multiple_companies = select_values(sql)
    if statements_belonging_to_multiple_companies.any?
      raise <<~MESSAGE
        Some statements are associated with multiple companies.
        I'm aborting because proceeding with the update would result in data being lost.
      MESSAGE
    end

    update <<~SQL
    UPDATE statements
    SET company_id = companies_statements.company_id
    FROM companies_statements
    WHERE statements.id = companies_statements.statement_id;
    SQL

    change_column_null :statements, :company_id, false
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
