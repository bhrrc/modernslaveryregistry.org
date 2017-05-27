class AddContentTypeAndResponseBodyAndContentLengthToStatements < ActiveRecord::Migration[5.0]
  def change
    add_column :statements, :content_type, :string
    add_column :statements, :content_data, :binary
    add_column :statements, :content_length, :integer
  end
end
