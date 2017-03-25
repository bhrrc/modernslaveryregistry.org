class CreateStatements < ActiveRecord::Migration[5.0]
  def change
    create_table :statements do |t|
      t.integer :company_id
      t.string :url
      t.date :date_seen
      t.string :approved_by_board
      t.string :approved_by
      t.boolean :signed_by_director
      t.string :signed_by
      t.boolean :link_on_front_page
      t.string :linked_from

      t.timestamps
    end
  end
end
