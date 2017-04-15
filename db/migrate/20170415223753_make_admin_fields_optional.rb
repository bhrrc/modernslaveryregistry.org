class MakeAdminFieldsOptional < ActiveRecord::Migration[5.0]
  def change
    change_column_null :statements, :approved_by_board, true
    change_column_null :statements, :signed_by_director, true
    change_column_null :statements, :link_on_front_page, true
  end
end
