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
    return {} unless calculatable_legislations_exist?

    ActiveRecord::Base.connection.execute(query).map do |result|
      {
        label: format_label(result['year_month']),
        statements: format_result(result['statements']),
        uk_act: format_result(result['uk_act']),
        us_act: format_result(result['us_act'])
      }
    end
  end

  private

  def format_label(result)
    year_number, month_number = result.split('-')
    [Date::MONTHNAMES[month_number.to_i], year_number].join(' ')
  end

  def format_result(result)
    result.nil? ? 0 : result.to_i
  end

  def calculatable_legislations_exist?
    Legislation.where(name: 'California Transparency in Supply Chains Act').exists? &&
      Legislation.where(name: 'UK Modern Slavery Act').exists?
  end

  def query
    <<~SQL
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
      ),
      cumulative_statements as (
        select
          year_month,
          sum(unique_statements) over (order by year_month asc rows between unbounded preceding and current row) as statements
        from unique_statements_published_per_month
      ),
      statements_under_uk_act as (
        select year_month, count(*) as uk_act
        from all_published_statements
        where name = 'UK Modern Slavery Act'
        group by year_month
      ),
      statements_under_us_act as (
        select year_month, count(*) as us_act
        from all_published_statements
        where name = 'California Transparency in Supply Chains Act'
        group by year_month
      )
       select * from cumulative_statements
      left join statements_under_us_act on cumulative_statements.year_month = statements_under_us_act.year_month
      left join statements_under_uk_act on cumulative_statements.year_month = statements_under_uk_act.year_month
    SQL
  end

  def published_statements_with_companies
    Statement.published.joins(:company)
  end
end
