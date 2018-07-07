class AddTimestampsToPages < ActiveRecord::Migration[5.2]
  def change
    add_timestamps :pages, default: Time.zone.now
    change_column_default :pages, :created_at, nil
    change_column_default :pages, :updated_at, nil
  end
end
