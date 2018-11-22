class AddAdditionalCompaniesCoveredToStatements < ActiveRecord::Migration[5.2]
  def up
    add_column :statements, :additional_companies_covered, :integer, default: 0

    Statement.where.not(also_covers_companies: nil).each do |statement|
      number = statement.also_covers_companies.split(',').size
      statement.update_attribute(:additional_companies_covered, number)
    end
  end

  def down
    remove_column :statements, :additional_companies_covered
  end
end
