require 'csv'

class StatementExport
  # Return an array of values that map to a given hash of fields. Optionally
  #   override the given statement's company with a new one using context.
  # rubocop:disable Metrics/MethodLength
  def self.to_csv(statement, fields, context: nil)
    company = context.nil? ? statement.company : context

    fields.map do |name, _|
      if send_company_context?(name)
        format_for_csv(statement.send(name, company))
      elsif %i[country_name industry_name].include? name
        format_for_csv(company.send(name))
      elsif name == :company_id
        format_for_csv(company.send(:id))
      else
        format_for_csv(statement.send(name))
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # Private class methods
  class << self
    private

    def format_for_csv(value)
      if value.respond_to?(:iso8601)
        value.iso8601
      elsif value.is_a?(Array)
        value.join(',')
      else
        value
      end
    end

    # Determine if a given Statement method requires a company param or not
    def send_company_context?(name)
      return false if Statement.new.method(name).parameters.empty?

      Statement.new.method(name).parameters[0][1] == :company
    end
  end
end
