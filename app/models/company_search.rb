class CompanySearch
  def initialize(company_name: nil, industries: [], countries: [], legislations: [])
    @company_name = company_name
    @industries = industries
    @countries = countries
    @legislations = legislations
  end

  def results
    company_scope
      .merge(filter_by_countries)
      .merge(filter_by_industries)
      .merge(filter_by_legislations)
  end

  def industry_stats
    IndustryGroupCounts.new(results).stats
  end

  def statement_count_for(company)
    return company.published_statements.count if @legislations.blank?

    company.statements.published.joins(:legislations).where(legislations: { id: @legislations }).count
  end

  private

  def company_scope
    if @company_name&.present?
      company_name_query = @company_name.split.join(' & ')
      Company.where(company_name_query_sql, company_name_query)
    else
      Company.all.order(:name)
    end
  end

  def company_name_query_sql
    <<-SQL
      to_tsvector(concat_ws(' ', companies.name, companies.related_companies)) @@
      ts_rewrite(plainto_tsquery(?), 'SELECT target, substitute FROM search_aliases')
    SQL
  end

  def filter_by_countries
    return Company.all if @countries.blank?

    Company.joins(:country).where(companies: { country: @countries })
  end

  def filter_by_industries
    return Company.all if @industries.blank?

    Company.joins(:industry).where(companies: { industry: @industries })
  end

  def filter_by_legislations
    return Company.all if @legislations.blank?

    Company.joins(statements: :legislations).where(statements: { legislations: { id: @legislations } }).distinct
  end
end
