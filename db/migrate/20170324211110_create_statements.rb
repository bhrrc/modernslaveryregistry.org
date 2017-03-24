class CreateStatements < ActiveRecord::Migration[5.0]
  def change
    create_table :statements do |t|
      t.integer :company_id
      t.string :url
      t.boolean :signed_by_director
      t.boolean :link_on_front_page
      t.boolean :approved_by_board

      t.timestamps
    end
  end
end
