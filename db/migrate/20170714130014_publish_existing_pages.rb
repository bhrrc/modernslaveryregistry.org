class PublishExistingPages < ActiveRecord::Migration[5.0]
  def up
    Page.update_all(published: true)
  end
end
