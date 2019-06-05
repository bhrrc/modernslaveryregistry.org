require 'csv'
namespace :import_company_data do
  desc 'Import Company numbers to company'
  task add_company_numbers: :environment do
    ActiveRecord::Base.transaction do
      data = CSV.read('public/companies_house_numbers_upload_v1.csv')
      data.shift
      data.each do |row|
        company = Company.find_by(id: row[0])
        if company
          company.update!(company_number: row[1])
        else
          STDERR.puts "No such company id: #{row[0]} - ignoring"
        end
      end
    end
  end
end
