class CreateCallToActions < ActiveRecord::Migration[5.2]
  def change
    create_table :call_to_actions do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.string :url, null: false
      t.string :button_text, null: false
    end
  end
end
