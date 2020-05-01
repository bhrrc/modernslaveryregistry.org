require 'csv'
namespace :import_audit_data do
  desc 'Import Company numbers to company'
  task add_audit_20200415: :environment do
    puts 'Starting...'
    companies = CSV.read('lib/tasks/fixtures/audit/companies.csv')
    company_columns = companies.shift
    statements = CSV.read('lib/tasks/fixtures/audit/statements.csv')
    statement_columns = statements.shift
    rows = 0
    count = 0
    invalid = 0

    statements.each do |s|
      statement_params = {}.with_indifferent_access
      statement_columns.each_with_index do |key, i|
        statement_params[key] = s[i]
      end
      params = statement_params.select { |key, _value| Statement.column_names.include?(key) }

      lead_company = nil
      additional_companies = []
      lead_company_id = params[:company_id]
      statement_company_ids = [lead_company_id, *statement_params[:related_companies]&.split(',')].uniq.compact

      ActiveRecord::Base.transaction do
        # create all new companies for this statement to belong to, find company information in `companies`
        statement_company_ids.each_with_index do |company_id, index|
          if company_id =~ /^NEW/
            imported_company_data = companies.find { |c| c[0] == company_id }
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
                # puts "Would save new company: #{company.name}"
                company.save
              else
                puts "Invalid new company:   #{company.inspect}"
                puts company.errors.inspect
              end
            end
          elsif company_id.to_i.positive?
            begin
              company = Company.find company_id
              # puts "Would use existing company: #{company.name}"
            rescue ActiveRecord::RecordNotFound
              puts "Company not found: #{company_id}"
              puts statement.inspect
              next
            end
          else
            puts "*ERROR*:  #{params.inspect}"
          end

          if index == 0
            lead_company = company
          else
            additional_companies << company
          end
        end
        # create the new Statement:
        # - if it doesn't already exist
        # - also create a `legislation_statements` association

        lead_company.statements.build(params) do |new_statement|
        # Statement.new(params) do |new_statement|
          # new_statement.company_id = lead_company.id
          if new_statement.valid?
            new_statement.home_office_audit = true
            # ^ set `home_office_audit` to TRUE, as all these imported statements are the result of an audit

            # puts "Would save: new statement for `#{lead_company.name}` in #{new_statement.last_year_covered}"
            new_statement.save

            # puts "Would save: new legislation_statements for `#{lead_company.name}` in #{new_statement.last_year_covered}"
            new_statement.legislation_statements.first_or_create(legislation_id: 1).save
            # ^ Given that all the new companies being imported in this audit are in the UK, all new statements shall be linked to the "UK Modern Slavery Act"

            # puts "Would save: new comapnies_statements for `#{additional_companies.length}` additional companies related to #{lead_company.name}"
            # puts additional_companies.map(&:name).inspect
            new_statement.additional_companies_covered << additional_companies

            # Update the lead company's `latest_statement_for_compliance_stats`
            lead_company.update(latest_statement_for_compliance_stats: new_statement)

            count += 1
          else
            puts "Invalid new statement: #{new_statement.company_id}"
            puts new_statement.url
            puts new_statement.errors.messages.inspect
            invalid += 1
          end
        end

      end # of AR Transacton
      rows += 1
    end # of `statements.each` loop

    puts "Finished."
    puts "Imported #{count} statements from #{rows} rows."
    puts "Invalid = #{invalid}." if invalid > 0
  end

  def format(value, index)
    return value unless index == 10
    
    return value if value.to_i == 0

    value.rjust(8, '0')
  end
end
