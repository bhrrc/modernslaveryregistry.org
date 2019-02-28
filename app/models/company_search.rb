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
  end

  def industry_stats
    counts = results.pluck(:industry_id).each_with_object(Hash.new(0)) do |id, count|
      count[id] += 1
    end

    groups = Industry.where(id: counts.keys).each_with_object([]) do |industry, array|
      array << GroupCount.with(group: industry, count: counts[industry.id])
    end

    groups.sort_by(&:count).reverse
  end

  def statement_count_for(company)
    return company.all_statements.count if @legislations.blank?

    company.statements.joins(:legislations).where(legislations: { id: @legislations }).count
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
end
