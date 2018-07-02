class StatementStats
  def uk_statements_count
    published_uk_statements.count
  end

  def california_statements_count
    published_california_statements.count
  end

  def uk_companies_count
    published_uk_statements.select('companies.id').distinct.count
  end

  def california_companies_count
    published_california_statements.select('companies.id').distinct.count
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
    # Temporary hack to work around a bug where result['year_month']
    # is nil. A better fix would be to fix the SQL query so this is impossible,
    # and/or to introduce stricter validation of statements so they cannot
    # be saved without a year_month field.
    return 'UNKNOWN' if result.nil?
    year_number, month_number = result.split('-')
    [Date::MONTHNAMES[month_number.to_i], year_number].join(' ')
  end

  def format_result(result)
    result.nil? ? 0 : result.to_i
  end

  def calculatable_legislations_exist?
    Legislation.where(name: Legislation::CALIFORNIA_NAME).exists? &&
      Legislation.where(name: Legislation::UK_NAME).exists?
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
      statements_under_uk_act as (
        select year_month, count(*) as uk_statements
        from all_published_statements
        where name = '#{Legislation::UK_NAME}'
        group by year_month
      ),
      statements_under_us_act as (
        select year_month, count(*) as us_statements
        from all_published_statements
        where name = '#{Legislation::CALIFORNIA_NAME}'
        group by year_month
      ),
      statements_table as (
        select
          unique_statements_published_per_month.year_month,
          unique_statements_published_per_month.unique_statements,
          case WHEN statements_under_uk_act.uk_statements is NULL then 0 ELSE statements_under_uk_act.uk_statements END AS uk_statements,
          case WHEN statements_under_us_act.us_statements is NULL then 0 ELSE statements_under_us_act.us_statements END AS us_statements
        from unique_statements_published_per_month
        left join statements_under_us_act on unique_statements_published_per_month.year_month = statements_under_us_act.year_month
        left join statements_under_uk_act on unique_statements_published_per_month.year_month = statements_under_uk_act.year_month
      )

      select
        year_month,
        sum(unique_statements) over (order by year_month asc rows between unbounded preceding and current row) as statements,
        sum(uk_statements) over (order by year_month asc rows between unbounded preceding and current row) as uk_act,
        sum(us_statements) over (order by year_month asc rows between unbounded preceding and current row) as us_act
      from statements_table
    SQL
  end

  def published_statements_with_companies_and_legislations_for(legislation_name)
    Statement.published.joins(:company).joins(:legislations).where('legislations.name' => legislation_name)
  end

  def published_uk_statements
    published_statements_with_companies_and_legislations_for(Legislation::UK_NAME)
  end

  def published_california_statements
    published_statements_with_companies_and_legislations_for(Legislation::CALIFORNIA_NAME)
  end
end
