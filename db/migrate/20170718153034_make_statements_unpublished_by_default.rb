class MakeStatementsUnpublishedByDefault < ActiveRecord::Migration[5.0]
  def change
    change_column :statements, :published, :boolean, default: false
  end
end
