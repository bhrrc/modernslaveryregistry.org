class AddPositionToCallToActions < ActiveRecord::Migration[5.2]
  def up
    add_column :call_to_actions, :position, :integer, default: 1

    CallToAction.order(:id).each.with_index(1) do |cta, index|
      cta.update_column(:position, index)
    end
  end

  def down
    remove_column :call_to_actions, :position
  end
end
