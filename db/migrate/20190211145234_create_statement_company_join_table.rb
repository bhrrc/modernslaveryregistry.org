class CreateStatementCompanyJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :companies, :statements do |t|
      t.index [:company_id, :statement_id]
      t.index [:statement_id, :company_id]
    end
  end
end
