module CompaniesHelper

  def linkable_company_number
    if @company.required_country?
      link_to("https://beta.companieshouse.gov.uk/company/#{@company.company_number}", target: :_blank) do
        raw(@company.company_number.presence || 'Company Number Unknown')
      end
    else
      @company.company_number.presence || 'Company Number Unknown'
    end
  end
end
