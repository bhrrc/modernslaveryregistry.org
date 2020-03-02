class CompanySearch
  def initialize(company_name: nil, industries: [], countries: [], legislations: [])
    @company_name = company_name

    @where = {}
    @where.merge!({ industry_id: industries }) if industries&.any?
    @where.merge!({ country_id: countries }) if countries&.any?
    @where.merge!({ legislation_ids: legislations }) if legislations&.any?
  end

  def results
    Company.search(
      @company_name.presence || '*',
      fields: [:name, :related_companies],
      where: @where
    )
  end

  def statement_count_for(company)
    return company.published_statements.count if @legislations.blank?

    company.published_statements.joins(:legislations).where(legislations: { id: @legislations }).count
  end
end
