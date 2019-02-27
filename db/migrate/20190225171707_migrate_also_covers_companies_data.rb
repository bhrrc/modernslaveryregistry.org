require 'csv'

class MigrateAlsoCoversCompaniesData < ActiveRecord::Migration[5.2]
  def up
    existing_company_ids = Company.all.pluck(:id)

    CSV.open(Rails.root.join('tmp', 'also-covers-companies-migration.csv'), "wb") do |csv|
      csv << ['Statement ID', 'Company name', 'New company?']

      Statement.find_each do |statement|
        next if statement.also_covers_companies.blank?

        associated_company_names = statement.also_covers_companies
                                   .split(',')
                                   .map { |name| name.gsub(/\t/, ' ') }
                                   .map(&:strip)
                                   .reject(&:blank?)

        associated_company_names.each do |company_name|
          company = Company.where(name: company_name).first_or_create
          statement.additional_companies_covered << company

          csv << [statement.id, company.name, existing_company_ids.exclude?(company.id)]
        end

        statement.update(also_covers_companies: nil)
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
