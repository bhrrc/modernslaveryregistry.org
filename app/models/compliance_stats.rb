class ComplianceStats
  attr_reader :industry

  def initialize(industry: false)
    @industry = industry
    @statements = Statement
                  .joins('INNER JOIN companies ON statements.id = companies.latest_statement_for_compliance_stats_id')
  end

  def total
    if @industry
      @statements
        .where('companies.industry_id = ?', industry.id)
        .count
    else
      @statements
        .count
    end
  end

  def approved_by_board_count
    if @industry
      @statements
        .where('companies.industry_id = ?', industry.id)
        .approved_by_board
        .count
    else
      @statements
        .approved_by_board
        .count
    end
  end

  def link_on_front_page_count
    if @industry
      @statements
        .where('companies.industry_id = ?', industry.id)
        .link_on_front_page
        .count
    else
      @statements
        .link_on_front_page
        .count
    end
  end

  def signed_by_director_count
    if @industry
      @statements
        .where('companies.industry_id = ?', industry.id)
        .signed_by_director
        .count
    else
      @statements
        .signed_by_director
        .count
    end
  end

  def fully_compliant_count
    if @industry
      @statements
        .where('companies.industry_id = ?', industry.id)
        .fully_compliant
        .count
    else
      @statements
        .fully_compliant
        .count
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

  private

  def percent_for_stat(stat)
    total.positive? ? ((stat.to_f / total.to_f) * 100).to_i : 0
  end
end
