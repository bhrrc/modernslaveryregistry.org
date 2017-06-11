class StatementSearch
  def initialize(admin, criteria)
    @admin = admin
    @criteria = criteria
  end

  def statements
    @statements = Statement.includes(:verified_by, company: %i[sector country])
    filter_by_published
    filter_by_company
    @statements.order('companies.name')
  end

  def stats
    {
      statements: statements.size,
      sectors: statements.select('companies.sector_id').distinct.count,
      countries: statements.select('companies.country_id').distinct.count
    }
  end

  def sector_stats
    counts = count_by_company_attribute(:sector_id)
    groups = Sector.where(id: counts.keys).each_with_object([]) do |sector, array|
      array << GroupCount.with(group: sector, count: counts[sector.id])
    end
    groups.sort_by(&:count).reverse
  end

  private

  def count_by_company_attribute(attribute)
    statements.select("companies.#{attribute}").pluck(attribute).each_with_object(Hash.new(0)) do |id, count|
      count[id] += 1
    end
  end

  def filter_by_published
    @statements = @admin ? @statements.latest : @statements.latest_published
  end

  def filter_by_company
    @company_join = @statements.joins(:company)
    filter_by_company_name
    filter_by_company_sector
    filter_by_company_country
  end

  def filter_by_company_name
    return if @criteria[:company_name].blank?
    @company_join = @company_join.where('LOWER(companies.name) LIKE LOWER(?)', "%#{@criteria[:company_name]}%")
    @statements = @company_join
  end

  def filter_by_company_sector
    return if @criteria[:sectors].blank?
    @company_join = @company_join.where(companies: { sector_id: @criteria[:sectors] })
    @statements = @company_join
  end

  def filter_by_company_country
    return if @criteria[:countries].blank?
    @company_join = @company_join.where(companies: { country_id: @criteria[:countries] })
    @statements = @company_join
  end
end
