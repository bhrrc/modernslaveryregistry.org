class SetDefaultAlsoCoversCompaniesFromSubsidiaryNames < ActiveRecord::Migration[5.0]
  def up
    Company.all.each do |company|
      unless company.subsidiary_names.blank?
        company.statements.each do |statement|
          puts statement.inspect
          statement.update_attributes!(also_covers_companies: company.subsidiary_names)
        end
      end
    end
  end
end
