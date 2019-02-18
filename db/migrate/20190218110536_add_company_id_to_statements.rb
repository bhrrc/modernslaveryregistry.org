class AddCompanyIdToStatements < ActiveRecord::Migration[5.2]
  def change
    add_reference :statements, :company
  end
end
