class MakeFieldsNotNull < ActiveRecord::Migration[5.0]
  def change
    change_column_null :companies, :name, false
    change_column_null :companies, :country_id, false

    change_column_null :countries, :code, false
    change_column_null :countries, :name, false

    change_column_null :sectors, :name, false

    change_column_null :statements, :url, false
    change_column_null :statements, :date_seen, false
    change_column_null :statements, :approved_by_board, false
    change_column_null :statements, :signed_by_director, false
    change_column_null :statements, :link_on_front_page, false
    change_column_null :statements, :company_id, false
  end
end
