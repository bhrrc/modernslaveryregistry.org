class StatementStats
  def statements_count
    @statements_count ||= statements.count
  end

  def companies_count
    @companies_count ||= statements.select('companies.id').distinct.count
  end

  def sectors_count
    statements.select('companies.sector_id').distinct.count
  end

  private

  def statements
    Statement.where(published: true).joins(:company)
  end
end
