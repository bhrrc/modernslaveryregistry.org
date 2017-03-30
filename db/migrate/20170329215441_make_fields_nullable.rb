class MakeFieldsNullable < ActiveRecord::Migration[5.0]
  def change
    change_column_null :statements, :approved_by, true
    change_column_null :statements, :signed_by, true
  end
end
