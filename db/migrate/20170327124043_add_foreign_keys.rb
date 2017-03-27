class AddForeignKeys < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :statements, :companies
    add_foreign_key :companies, :countries
  end
end
