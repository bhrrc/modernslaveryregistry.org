# rubocop:disable Metrics/ClassLength
class ComplianceStats
  attr_reader :industry

  def initialize(industry: false)
    @industry = industry
  end

  def total
    if @industry
      latest_published_statement_count_for(@industry)
    else
      latest_published_statement_count
    end
  end

  def approved_by_board_count
    if @industry
      latest_published_statements_approved_by_board_count_for(@industry)
    else
      latest_published_statements_approved_by_board_count
    end
  end

  def link_on_front_page_count
    if @industry
      latest_published_statements_link_on_front_page_count_for(@industry)
    else
      latest_published_statements_link_on_front_page_count
    end
  end

  def signed_by_director_count
    if @industry
      latest_published_statements_signed_by_director_count_for(@industry)
    else
      latest_published_statements_signed_by_director_count
    end
  end

  def fully_compliant_count
    if @industry
      latest_published_statements_fully_compliant_count_for(@industry)
    else
      latest_published_statements_fully_compliant_count
    end
  end

  def percent_approved_by_board
    percent_for_stat(approved_by_board_count)
  end

  def percent_link_on_front_page
    percent_for_stat(link_on_front_page_count)
  end

  def percent_signed_by_director
    percent_for_stat(signed_by_director_count)
  end

  def percent_fully_compliant
    percent_for_stat(fully_compliant_count)
  end

  # rubocop:disable Metrics/MethodLength
  def latest_published_statement_count
    sql = <<~SQL
      WITH statements_included_in_compliance_stats AS (
        SELECT statements.* FROM statements
        INNER JOIN legislation_statements ON statements.id = legislation_statements.statement_id
        INNER JOIN legislations ON legislations.id = legislation_statements.legislation_id
        WHERE legislations.include_in_compliance_stats IS TRUE
      ),
      published_statements AS (
        SELECT statements.*,
               ROW_NUMBER() OVER(PARTITION BY statements.company_id
                                 ORDER BY statements.last_year_covered DESC, statements.date_seen DESC) AS reverse_publication_order
        FROM statements_included_in_compliance_stats AS statements
        WHERE published IS TRUE )

      SELECT COUNT(id) FROM published_statements
      WHERE reverse_publication_order = 1
    SQL

    Statement.connection.select_value(sql)
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def latest_published_statement_count_for(industry)
    sql = <<~SQL
      WITH statements_included_in_compliance_stats AS (
        SELECT statements.* FROM statements
        INNER JOIN legislation_statements ON statements.id = legislation_statements.statement_id
        INNER JOIN legislations ON legislations.id = legislation_statements.legislation_id
        WHERE legislations.include_in_compliance_stats IS TRUE
      ),
      published_statements AS (
        SELECT statements.*,
               ROW_NUMBER() OVER(PARTITION BY statements.company_id
                                 ORDER BY statements.last_year_covered DESC, statements.date_seen DESC) AS reverse_publication_order
        FROM statements_included_in_compliance_stats AS statements
        WHERE published IS TRUE )

      SELECT COUNT(published_statements.id) FROM published_statements
      INNER JOIN companies ON published_statements.company_id = companies.id
      WHERE reverse_publication_order = 1
      AND companies.industry_id = #{industry.id}
    SQL

    Statement.connection.select_value(sql)
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def latest_published_statements_approved_by_board_count
    sql = <<~SQL
      WITH statements_included_in_compliance_stats AS (
        SELECT statements.* FROM statements
        INNER JOIN legislation_statements ON statements.id = legislation_statements.statement_id
        INNER JOIN legislations ON legislations.id = legislation_statements.legislation_id
        WHERE legislations.include_in_compliance_stats IS TRUE
      ),
      published_statements AS (
        SELECT statements.*,
               ROW_NUMBER() OVER(PARTITION BY statements.company_id
                                 ORDER BY statements.last_year_covered DESC, statements.date_seen DESC) AS reverse_publication_order
        FROM statements_included_in_compliance_stats AS statements
        WHERE published IS TRUE )

      SELECT COUNT(id) FROM published_statements
      WHERE reverse_publication_order = 1
      AND approved_by_board = 'Yes'
    SQL

    Statement.connection.select_value(sql)
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def latest_published_statements_approved_by_board_count_for(industry)
    sql = <<~SQL
      WITH statements_included_in_compliance_stats AS (
        SELECT statements.* FROM statements
        INNER JOIN legislation_statements ON statements.id = legislation_statements.statement_id
        INNER JOIN legislations ON legislations.id = legislation_statements.legislation_id
        WHERE legislations.include_in_compliance_stats IS TRUE
      ),
      published_statements AS (
        SELECT statements.*,
               ROW_NUMBER() OVER(PARTITION BY statements.company_id
                                 ORDER BY statements.last_year_covered DESC, statements.date_seen DESC) AS reverse_publication_order
        FROM statements_included_in_compliance_stats AS statements
        WHERE published IS TRUE )

      SELECT COUNT(published_statements.id) FROM published_statements
      INNER JOIN companies ON published_statements.company_id = companies.id
      WHERE reverse_publication_order = 1
      AND companies.industry_id = #{industry.id}
      AND approved_by_board = 'Yes'
    SQL

    Statement.connection.select_value(sql)
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def latest_published_statements_link_on_front_page_count
    sql = <<~SQL
      WITH statements_included_in_compliance_stats AS (
        SELECT statements.* FROM statements
        INNER JOIN legislation_statements ON statements.id = legislation_statements.statement_id
        INNER JOIN legislations ON legislations.id = legislation_statements.legislation_id
        WHERE legislations.include_in_compliance_stats IS TRUE
      ),
      published_statements AS (
        SELECT statements.*,
               ROW_NUMBER() OVER(PARTITION BY statements.company_id
                                 ORDER BY statements.last_year_covered DESC, statements.date_seen DESC) AS reverse_publication_order
        FROM statements_included_in_compliance_stats AS statements
        WHERE published IS TRUE )

      SELECT COUNT(id) FROM published_statements
      WHERE reverse_publication_order = 1
      AND link_on_front_page = true
    SQL

    Statement.connection.select_value(sql)
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def latest_published_statements_link_on_front_page_count_for(industry)
    sql = <<~SQL
      WITH statements_included_in_compliance_stats AS (
        SELECT statements.* FROM statements
        INNER JOIN legislation_statements ON statements.id = legislation_statements.statement_id
        INNER JOIN legislations ON legislations.id = legislation_statements.legislation_id
        WHERE legislations.include_in_compliance_stats IS TRUE
      ),
      published_statements AS (
        SELECT statements.*,
               ROW_NUMBER() OVER(PARTITION BY statements.company_id
                                 ORDER BY statements.last_year_covered DESC, statements.date_seen DESC) AS reverse_publication_order
        FROM statements_included_in_compliance_stats AS statements
        WHERE published IS TRUE )

      SELECT COUNT(published_statements.id) FROM published_statements
      INNER JOIN companies ON published_statements.company_id = companies.id
      WHERE reverse_publication_order = 1
      AND companies.industry_id = #{industry.id}
      AND link_on_front_page = true
    SQL

    Statement.connection.select_value(sql)
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def latest_published_statements_signed_by_director_count
    sql = <<~SQL
      WITH statements_included_in_compliance_stats AS (
        SELECT statements.* FROM statements
        INNER JOIN legislation_statements ON statements.id = legislation_statements.statement_id
        INNER JOIN legislations ON legislations.id = legislation_statements.legislation_id
        WHERE legislations.include_in_compliance_stats IS TRUE
      ),
      published_statements AS (
        SELECT statements.*,
               ROW_NUMBER() OVER(PARTITION BY statements.company_id
                                 ORDER BY statements.last_year_covered DESC, statements.date_seen DESC) AS reverse_publication_order
        FROM statements_included_in_compliance_stats AS statements
        WHERE published IS TRUE )

      SELECT COUNT(id) FROM published_statements
      WHERE reverse_publication_order = 1
      AND signed_by_director = true
    SQL

    Statement.connection.select_value(sql)
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def latest_published_statements_signed_by_director_count_for(industry)
    sql = <<~SQL
      WITH statements_included_in_compliance_stats AS (
        SELECT statements.* FROM statements
        INNER JOIN legislation_statements ON statements.id = legislation_statements.statement_id
        INNER JOIN legislations ON legislations.id = legislation_statements.legislation_id
        WHERE legislations.include_in_compliance_stats IS TRUE
      ),
      published_statements AS (
        SELECT statements.*,
               ROW_NUMBER() OVER(PARTITION BY statements.company_id
                                 ORDER BY statements.last_year_covered DESC, statements.date_seen DESC) AS reverse_publication_order
        FROM statements_included_in_compliance_stats AS statements
        WHERE published IS TRUE )

      SELECT COUNT(published_statements.id) FROM published_statements
      INNER JOIN companies ON published_statements.company_id = companies.id
      WHERE reverse_publication_order = 1
      AND companies.industry_id = #{industry.id}
      AND signed_by_director = true
    SQL

    Statement.connection.select_value(sql)
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def latest_published_statements_fully_compliant_count
    sql = <<~SQL
      WITH statements_included_in_compliance_stats AS (
        SELECT statements.* FROM statements
        INNER JOIN legislation_statements ON statements.id = legislation_statements.statement_id
        INNER JOIN legislations ON legislations.id = legislation_statements.legislation_id
        WHERE legislations.include_in_compliance_stats IS TRUE
      ),
      published_statements AS (
        SELECT statements.*,
               ROW_NUMBER() OVER(PARTITION BY statements.company_id
                                 ORDER BY statements.last_year_covered DESC, statements.date_seen DESC) AS reverse_publication_order
        FROM statements_included_in_compliance_stats AS statements
        WHERE published IS TRUE )

      SELECT COUNT(id) FROM published_statements
      WHERE reverse_publication_order = 1
      AND approved_by_board = 'Yes'
      AND link_on_front_page IS TRUE
      AND signed_by_director IS TRUE
    SQL

    Statement.connection.select_value(sql)
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def latest_published_statements_fully_compliant_count_for(industry)
    sql = <<~SQL
      WITH statements_included_in_compliance_stats AS (
        SELECT statements.* FROM statements
        INNER JOIN legislation_statements ON statements.id = legislation_statements.statement_id
        INNER JOIN legislations ON legislations.id = legislation_statements.legislation_id
        WHERE legislations.include_in_compliance_stats IS TRUE
      ),
      published_statements AS (
        SELECT statements.*,
               ROW_NUMBER() OVER(PARTITION BY statements.company_id
                                 ORDER BY statements.last_year_covered DESC, statements.date_seen DESC) AS reverse_publication_order
        FROM statements_included_in_compliance_stats AS statements
        WHERE published IS TRUE )

      SELECT COUNT(published_statements.id) FROM published_statements
      INNER JOIN companies ON published_statements.company_id = companies.id
      WHERE reverse_publication_order = 1
      AND companies.industry_id = #{industry.id}
      AND approved_by_board = 'Yes'
      AND link_on_front_page IS TRUE
      AND signed_by_director IS TRUE
    SQL

    Statement.connection.select_value(sql)
  end
  # rubocop:enable Metrics/MethodLength

  private

  def percent_for_stat(stat)
    total.positive? ? ((stat.to_f / total.to_f) * 100).to_i : 0
  end
end
# rubocop:enable Metrics/ClassLength
