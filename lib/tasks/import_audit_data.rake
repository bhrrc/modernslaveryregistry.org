require 'csv'
namespace :import_audit_data do
  desc 'Import Company numbers to company'
  task add_audit_20200415: :environment do
    puts 'Starting...'
    companies = CSV.read('lib/tasks/fixtures/audit/companies.csv')
    company_columns = companies.shift
    statements = CSV.read('lib/tasks/fixtures/audit/statements.csv')
    statement_columns = statements.shift

    statements.each do |s|
      statement_params = {}.with_indifferent_access
      statement_columns.each_with_index do |key, i|
        statement_params[key] = s[i]
      end
      params = statement_params.select { |key, _value| Statement.column_names.include?(key) }
      company_id = params[:company_id].to_i

      ActiveRecord::Base.transaction do
        # create a new company for this statement to belong to, find it's information in `companies`
        if params[:company_id] =~ /^NEW/
          imported_company_data = companies.find { |c| c[0] == params[:company_id] }
          company_params = {}.with_indifferent_access
          company_columns.each_with_index do |key, i|
            company_params[key] = format(imported_company_data[i], i) unless i.zero?
            # ^ do not use the supplied :id, which is in the first column
          end
          company = Company.find_by(company_number: company_params[:company_number].rjust(8, '0'))
          company ||= Company.find_by(name: company_params[:name])
          company ||= Company.new(company_params)
          if company.new_record?
            if company.valid?
              # puts "would save new company: #{company.name}"
              company.save
            else
              puts "Invalid new company:   #{company.inspect}"
              puts company.errors.inspect
            end
          end
        elsif company_id.positive?
          begin
            company = Company.find company_id
          rescue ActiveRecord::RecordNotFound
            puts "Company not found: #{company_id}"
            puts statement.inspect
            next
          end
        else
          puts "*ERROR*:  #{params.inspect}"
        end

        # create the new Statement:
        # - if it doesn't already exist
        # - also create a `legislation_statements` association
        company.statements.first_or_create(params) do |new_statement|
          if new_statement.valid?
            new_statement.home_office_audit = true
            # ^ set `home_office_audit` to TRUE, as all these imported statements are the result of an audit
            new_statement.save
            # puts "would save: new statement for `#{company.name}` in #{new_statement.last_year_covered}"
            new_statement.legislation_statements.first_or_create(legislation_id: 1).save
            # ^ Given that all the new companies being imported in this audit are in the UK, all new statements shall be linked to the "UK Modern Slavery Act"
          else
            puts "Invalid new statement: #{new_statement.company_id}"
            puts new_statement.url
            puts new_statement.errors.messages.inspect
          end
        end
      end # of AR Transacton
    end # of `statements.each` loop
    puts 'Finished.'
  end

  def format(value, index)
    return value unless index == 10
    
    return value if value.to_i == 0

    value.rjust(8, '0')
  end
end
