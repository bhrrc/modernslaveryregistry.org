class AddIndexesToCompanyNames < ActiveRecord::Migration[5.2]
  def change
    add_index :companies, :name, using: :gist, opclass: {name: :gist_trgm_ops}
    add_index :companies, :subsidiary_names, using: :gist, opclass: {subsidiary_names: :gist_trgm_ops}
  end
end
