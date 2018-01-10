class SetDefaultRequiresStatementAttributesInLegislations < ActiveRecord::Migration[5.0]
  def up
    Legislation.where(name: 'UK Modern Slavery Act').update_all(
      requires_statement_attributes: 'approved_by_board,signed_by_director,link_on_front_page'
    )
  end
end
