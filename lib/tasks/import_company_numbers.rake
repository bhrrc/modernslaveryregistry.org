require 'csv'
namespace :import_company_data do
  desc 'Import Company numbers to company'
  task :add_company_numbers => :environment do
    ActiveRecord::Base.transaction do
      data = CSV.read('public/companies_house_numbers_upload_v1.csv')
      data.shift
      data.map do |row|
        company = Company.find_by_id(row[0])
        raise ActiveRecord::Rollback if company.blank?
        company.update!(company_number: row[1])
        puts "#{company.id} => #{row[1]} company_number Updated"
      end
    end
  end
end
