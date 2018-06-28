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
    published_statements_grouped_by_months_with_totals.map do |result|
      year_number, month_number = result['year_month'].split('-')
      {
        label: [Date::MONTHNAMES[month_number.to_i], year_number].join(' '),
        statements: result['statements'].to_i
      }
    end
  end

  private

  def published_statements_grouped_by_months_with_totals
    query = <<-SQL
with all_published_statements as (
  select
    statements.id as statement_id,
    to_char(statements.date_seen, 'YYYY-MM') as year_month,
    legislations.name
  from legislation_statements
  join statements on legislation_statements.statement_id = statements.id
  join legislations on legislation_statements.legislation_id = legislations.id
  where statements.published IS TRUE
),
unique_statements_published_per_month as (
  select year_month, count(distinct(statement_id)) as unique_statements
  from all_published_statements
  group by year_month
  order by year_month
), cumulative_statements as (
  select
    year_month,
    sum(unique_statements) over (order by year_month asc rows between unbounded preceding and current row) as statements
  from unique_statements_published_per_month
)

select * from cumulative_statements
    SQL

    ActiveRecord::Base.connection.execute(query)
  end

  def published_statements_with_companies
    Statement.published.joins(:company)
  end
end
