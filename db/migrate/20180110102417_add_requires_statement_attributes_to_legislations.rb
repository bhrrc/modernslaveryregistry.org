class AddRequiresStatementAttributesToLegislations < ActiveRecord::Migration[5.0]
  def change
    add_column :legislations, :requires_statement_attributes, :string, default: '', null: false
  end
end
