class StatementSearch
  def initialize(admin, query)
    @admin = admin
    @query = query
  end

  def statements
    @statements = Statement.newest.includes(:verified_by, company: %i[sector country])
    filter_by_published
    filter_by_company
    @statements
  end

  private

  def filter_by_published
    @statements = @statements.published unless @admin
  end

  def filter_by_company
    @company_join = @statements.joins(:company)
    filter_by_company_name
    filter_by_company_sector
    filter_by_company_country
  end

  def filter_by_company_name
    return if @query[:company_name].blank?
    @company_join = @company_join.where('LOWER(name) LIKE LOWER(?)', "%#{@query[:company_name]}%")
    @statements = @company_join
  end

  def filter_by_company_sector
    return if @query[:sectors].blank?
    @company_join = @company_join.where(companies: { sector_id: @query[:sectors] })
    @statements = @company_join
  end

  def filter_by_company_country
    return if @query[:countries].blank?
    @company_join = @company_join.where(companies: { country_id: @query[:countries] })
    @statements = @company_join
  end
end
