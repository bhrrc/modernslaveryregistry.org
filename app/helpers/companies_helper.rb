module CompaniesHelper
  def linkable_company_number
    return false unless @company.present? && @company.company_number.present?

    if @company.required_country?
      link_to("https://beta.companieshouse.gov.uk/company/#{@company.company_number}",
              target: '_blank',
              rel: 'noopener') do
        content_tag(:p, @company.company_number.to_s)
      end
    else
      @company.company_number
    end
  end
end
