class StatementStats
  def statements_count
    @statements_count ||= published_statements_with_companies.count
  end

  def companies_count
    @companies_count ||= published_statements_with_companies.select('companies.id').distinct.count
  end

  def industries_count
    published_statements_with_companies.select('companies.industry_id').distinct.count
  end

  def total_statements_over_time
    published_statements_grouped_by_months_with_totals.map do |item|
      { label: Date::MONTHNAMES[item[:month]] + ' ' + item[:year].to_s, statements: item[:total] }
    end
  end

  private

  def published_statements_grouped_by_months_with_totals
    published_statements_grouped_by_months.each_with_object([]) do |item, array|
      item[:total] = (array.last || { total: 0 })[:total] + item[:count]
      array << item
    end
  end

  def published_statements_grouped_by_months
    Statement.published.group("TO_CHAR(date_seen, 'YYYY-MM')").count.sort.map do |k, count|
      {
        year: k.split('-')[0].to_i,
        month: k.split('-')[1].to_i,
        count: count
      }
    end
  end

  def published_statements_with_companies
    Statement.published.joins(:company)
  end
end
