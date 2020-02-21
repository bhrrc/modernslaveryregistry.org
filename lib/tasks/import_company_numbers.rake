require 'csv'
namespace :import_company_data do
  desc 'Import Company numbers to company'
  task add_company_numbers: :environment do
    ActiveRecord::Base.transaction do
      data = CSV.read('lib/tasks/fixtures/companies_house_numbers_upload_v2.csv')
      data.shift
      failed_attempts = 0

      data.each do |row|
        company = Company.find_by(id: row[0])
        if company
          begin
            company_number = row[1].rjust(8, '0')
            company.update!(company_number: company_number)
          rescue ActiveRecord::RecordInvalid => e
            puts "Updating Company##{company.id} '#{company.name}'"
            puts "A company already exists with a #{company_number}"

            existing_company = Company.find_by_company_number(company_number)
            puts "Existing Company##{existing_company.id} #{existing_company.name}"
            puts ""
            failed_attempts += 1
          end
        else
          puts "No such company id: #{row[0]} - ignoring"
        end
      end

      puts "Failed attempts: #{failed_attempts}"
    end
  end
end
