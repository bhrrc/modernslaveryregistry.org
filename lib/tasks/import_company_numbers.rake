require 'csv'
namespace :import_company_data do
  desc 'Import Company numbers to company'
  task :add_company_numbers => :environment do
  	 records = CSV.foreach('public/companies_house_numbers_upload_v1.csv').map do |row|
  	 	company = Company.find_by_id(row[0])
  	 	company.update(company_number: row[1]) if company.present? && row[1].present?
  	 end
  end
end
