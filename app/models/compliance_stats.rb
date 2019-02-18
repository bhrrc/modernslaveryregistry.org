class ComplianceStats
  def initialize(counts, total)
    @counts = counts
    @total = total
  end

  # rubocop:disable Metrics/MethodLength
  def self.latest_published_statement_ids
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

      SELECT id FROM published_statements
      WHERE reverse_publication_order = 1
    SQL

    Statement.connection.select_values(sql)
  end

  def self.compile
    statements = Statement.where(id: latest_published_statement_ids)
    total = statements.count
    counts = {
      approved_by_board: statements.where(approved_by_board: 'Yes').count,
      link_on_front_page?: statements.where(link_on_front_page: true).count,
      signed_by_director?: statements.where(signed_by_director: true).count,
      fully_compliant?: statements
             .where(approved_by_board: 'Yes')
             .where(link_on_front_page: true)
             .where(signed_by_director: true).count
    }
    ComplianceStats.new(counts, total)
  end
  # rubocop:enable Metrics/MethodLength

  def percent_approved_by_board
    percent_for_stat :approved_by_board
  end

  def percent_link_on_front_page
    percent_for_stat :link_on_front_page?
  end

  def percent_signed_by_director
    percent_for_stat :signed_by_director?
  end

  def percent_fully_compliant
    percent_for_stat :fully_compliant?
  end

  private

  def percent_for_stat(stat)
    @total.positive? ? ((@counts[stat].to_f / @total.to_f) * 100).to_i : 0
  end
end
