class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.string :title, null: false
      t.string :short_title, null: false
      t.string :slug, null: false
      t.text :body_html, null: false
      t.integer :position, null: false
    end
    add_index :pages, :slug, unique: true
  end
end
