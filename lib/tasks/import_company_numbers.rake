require 'csv'
namespace :import_company_data do
  desc 'Import Company numbers to company'
  task :add_company_numbers => :environment do
  	CSV.foreach('public/companies_house_numbers_upload_v1.csv').map do |row|
  	 	company = Company.find_by_id(row[0])
  	 	if company.present?
  	 		company.update(company_number: row[1]) if row[1].present?
  	 		puts "#{company.id} => #{row[1]} company_number Updated"
  	 	else
  	 		puts "#{company&.id} => #{row[1]} Company not present"
  	 	end
  	 end
  end
end
