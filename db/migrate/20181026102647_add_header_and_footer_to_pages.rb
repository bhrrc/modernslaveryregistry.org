class AddHeaderAndFooterToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :header, :boolean, default: true
    add_column :pages, :footer, :boolean, default: true

    Page.update(:all, header: true, footer: true);
  end
end
