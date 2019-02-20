class StatementSearch
  def initialize(criteria)
    @criteria = criteria
  end

  def results
    @results = Statement.includes(:legislations, company: %i[industry country])
    filter_by_published
    filter_by_company
    filter_by_legislations
    @results.order('companies.name', 'date_seen DESC')
  end

  def stats
    {
      statements: results.size,
      industries: results.select('companies.industry_id').distinct.count,
      countries: results.select('companies.country_id').distinct.count
    }
  end

  def industry_stats
    counts = count_by_company_attribute(:industry_id)
    groups = Industry.where(id: counts.keys).each_with_object([]) do |industry, array|
      array << GroupCount.with(group: industry, count: counts[industry.id])
    end
    groups.sort_by(&:count).reverse
  end

  private

  def count_by_company_attribute(attribute)
    results.select("companies.#{attribute}").pluck(attribute).each_with_object(Hash.new(0)) do |id, count|
      count[id] += 1
    end
  end

  def filter_by_published
    @results = @results.published
  end

  def filter_by_company
    @company_join = @results.joins(:company)
    filter_by_company_name
    filter_by_company_industry
    filter_by_company_country
  end

  def filter_by_company_name
    return if @criteria[:company_name].blank?

    query = @criteria[:company_name].split.join(' & ')
    @company_join = @company_join.where(company_search_query, query)
    @results = @company_join
  end

  def company_search_query
    <<-SQL
      to_tsvector(concat_ws(' ', companies.name, companies.related_companies, statements.also_covers_companies)) @@
      ts_rewrite(plainto_tsquery(?), 'SELECT target, substitute FROM search_aliases')
    SQL
  end

  def filter_by_company_industry
    return if @criteria[:industries].blank?

    @company_join = @company_join.where(companies: { industry_id: @criteria[:industries] })
    @results = @company_join
  end

  def filter_by_company_country
    return if @criteria[:countries].blank?

    @company_join = @company_join.where(companies: { country_id: @criteria[:countries] })
    @results = @company_join
  end

  def filter_by_legislations
    return if @criteria[:legislations].blank?

    @results = @results.joins(:legislations).where(legislations: { id: @criteria[:legislations] })
  end
end
