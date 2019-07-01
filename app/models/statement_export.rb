require 'csv'

class StatementExport
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def self.to_csv(companies, admin)
    fields = BASIC_FIELDS.merge(admin ? EXTRA_FIELDS : {})
    CSV.generate do |csv|
      csv << fields.map { |_, heading| heading }
      companies = companies.includes(
        { statements: :legislations },
        { statements: :verified_by },
        :country,
        :industry
      )
      companies.find_each do |company|
        company.statements.each do |statement|
          next unless statement.published || admin

          csv << fields.map do |name, _|
            if send_company_context?(name)
              format_for_csv(statement.send(name, company))
            else
              format_for_csv(statement.send(name))
            end
          end

          csv_for_additional_companies(csv, fields, company, statement)
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  def self.format_for_csv(value)
    if value.respond_to?(:iso8601)
      value.iso8601
    elsif value.is_a?(Array)
      value.join(',')
    else
      value
    end
  end

  # rubocop:disable Metrics/MethodLength
  def self.csv_for_additional_companies(csv, fields, company, statement)
    # A lookup hash to substitute a different message to send to Statement
    #  in special cases
    substitute_message_for = {
      company_id: 'id',
      country_name: 'country_name',
      industry_name: 'industry_name'
    }

    statement.additional_companies_covered_excluding(company).each do |assoc_company|
      csv << fields.map do |name, _|
        if send_company_context?(name)
          format_for_csv(statement.send(name, assoc_company))
        elsif substitute_message_for[name]
          value = assoc_company.send(substitute_message_for[name])
          format_for_csv(value)
        else
          format_for_csv(statement.send(name))
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  def self.send_company_context?(name)
    return false if Statement.new.method(name).parameters.empty?

    Statement.new.method(name).parameters[0][1] == :company
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
