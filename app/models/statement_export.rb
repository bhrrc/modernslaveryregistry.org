require 'csv'

class StatementExport
  # rubocop:disable Metrics/MethodLength
  def self.to_csv(companies, admin)
    fields = BASIC_FIELDS.merge(admin ? EXTRA_FIELDS : {})
    CSV.generate do |csv|
      csv << fields.map { |_, heading| heading }
      companies.includes(
        { statements: :legislations },
        { statements: :verified_by },
        :country,
        :industry
      ).find_each do |company|

        company.statements.each do |statement|
          next unless statement.published || admin

          csv << fields.map do |name, _| 
            # REFACTOR:  try introspection to detect if the
            # method takes args and therefore needs the new context of a child
            # company
            #
            # if statement.method(name).parameters
            #   byebug # method and it takes arguments
            # end
            if name == :published_by?
              format_for_csv(statement.send(name, company)) 
            else
              format_for_csv(statement.send(name)) 
            end
          end

          # Create a row for each associated company (child)
          statement.additional_companies_covered_excluding(company).each do |company|
            csv << fields.map do |name, _| 

              case name
              when :published_by?
                format_for_csv(statement.send(name, company)) 
              when :company_name
                format_for_csv(statement.send(name, company))
              when :company_number
                format_for_csv(statement.send(name, company))
              when :company_id
                format_for_csv(company.id)
              when :country_name
                format_for_csv(company.country_name)
              when :industry_name
                format_for_csv(company.industry_name)
              when :also_covers_companies
                format_for_csv(statement.send(:also_covers_companies_excluding, company))
              else
                format_for_csv(statement.send(name)) 
              end

            end
          end
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  def self.format_for_csv(value)
    if value.respond_to?(:iso8601)
      value.iso8601
    elsif value.is_a?(Array)
      value.join(',')
    else
      value
    end
  end

  BASIC_FIELDS = {
    company_name: 'Company',
    published_by?: 'Is Publisher',
    id: 'Statement ID',
    url: 'URL',
    company_number: 'Company Number',
    industry_name: 'Industry',
    country_name: 'HQ',
    also_covers_companies: 'Also Covers Companies',
    also_covered?: 'Is Also Covered',
    'uk_modern_slavery_act?' => Legislation::UK_NAME,
    'california_transparency_in_supply_chains_act?' => Legislation::CALIFORNIA_NAME,
    # TODO - this might not be correct for the child companies
    period_covered: 'Period Covered'
  }.freeze

  EXTRA_FIELDS = {
    approved_by_board: 'Approved by Board',
    approved_by: 'Approved by',
    signed_by_director: 'Signed by Director',
    signed_by: 'Signed by',
    link_on_front_page: 'Link on Front Page',
    published: 'Published',
    verified_by_email: 'Verified by',
    contributor_email: 'Contributed by',
    broken_url: 'Broken URL',
    company_id: 'Company ID'
  }.freeze
end
