require 'csv'
namespace :import_company_data do
  desc 'Import Company numbers to company'
  task add_company_numbers: :environment do
    ActiveRecord::Base.transaction do
      data = CSV.read('lib/tasks/fixtures/companies_house_numbers_upload_v2.csv')
      data.shift

      data.each do |row|
        company = Company.find_by(id: row[0])
        if company
          puts company.id if company.company_number.present? && company.company_number != row[1]
          # company.update!(company_number: row[1])
        else
          puts "No such company id: #{row[0]} - ignoring"
        end
      end
    end
  end
end
