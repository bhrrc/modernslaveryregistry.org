class AddSearchAliases < ActiveRecord::Migration[5.2]
  def up
    execute "CREATE TABLE search_aliases (id bigserial primary key, target tsquery, substitute tsquery);"
    execute "INSERT INTO search_aliases VALUES(DEFAULT, to_tsquery('ltd'), to_tsquery('limited|ltd'));"
    execute "INSERT INTO search_aliases VALUES(DEFAULT, to_tsquery('limited'), to_tsquery('limited|ltd'));"
  end

  def down
    drop_table :search_aliases
  end
end
