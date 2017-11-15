class CreateLegislationStatements < ActiveRecord::Migration[5.0]
  def change
    create_table :legislation_statements do |t|
      t.references :legislation, foreign_key: true, null: false
      t.references :statement, foreign_key: true, null: false

      t.timestamps
    end
  end
end
