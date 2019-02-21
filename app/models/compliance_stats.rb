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

  def latest_published_statement_count
    Statement
      .joins('INNER JOIN companies ON statements.id = companies.latest_statement_for_compliance_stats_id')
      .count
  end

  def latest_published_statement_count_for(industry)
    Statement
      .joins('INNER JOIN companies ON statements.id = companies.latest_statement_for_compliance_stats_id')
      .where('companies.industry_id = ?', industry.id)
      .count
  end

  def latest_published_statements_approved_by_board_count
    Statement
      .joins('INNER JOIN companies ON statements.id = companies.latest_statement_for_compliance_stats_id')
      .where(approved_by_board: 'Yes')
      .count
  end

  def latest_published_statements_approved_by_board_count_for(industry)
    Statement
      .joins('INNER JOIN companies ON statements.id = companies.latest_statement_for_compliance_stats_id')
      .where('companies.industry_id = ?', industry.id)
      .where(approved_by_board: 'Yes')
      .count
  end

  def latest_published_statements_link_on_front_page_count
    Statement
      .joins('INNER JOIN companies ON statements.id = companies.latest_statement_for_compliance_stats_id')
      .where(link_on_front_page: true)
      .count
  end

  def latest_published_statements_link_on_front_page_count_for(industry)
    Statement
      .joins('INNER JOIN companies ON statements.id = companies.latest_statement_for_compliance_stats_id')
      .where('companies.industry_id = ?', industry.id)
      .where(link_on_front_page: true)
      .count
  end

  def latest_published_statements_signed_by_director_count
    Statement
      .joins('INNER JOIN companies ON statements.id = companies.latest_statement_for_compliance_stats_id')
      .where(signed_by_director: true)
      .count
  end

  def latest_published_statements_signed_by_director_count_for(industry)
    Statement
      .joins('INNER JOIN companies ON statements.id = companies.latest_statement_for_compliance_stats_id')
      .where('companies.industry_id = ?', industry.id)
      .where(signed_by_director: true)
      .count
  end

  def latest_published_statements_fully_compliant_count
    Statement
      .joins('INNER JOIN companies ON statements.id = companies.latest_statement_for_compliance_stats_id')
      .where(approved_by_board: 'Yes')
      .where(link_on_front_page: true)
      .where(signed_by_director: true)
      .count
  end

  def latest_published_statements_fully_compliant_count_for(industry)
    Statement
      .joins('INNER JOIN companies ON statements.id = companies.latest_statement_for_compliance_stats_id')
      .where('companies.industry_id = ?', industry.id)
      .where(approved_by_board: 'Yes')
      .where(link_on_front_page: true)
      .where(signed_by_director: true)
      .count
  end

  private

  def percent_for_stat(stat)
    total.positive? ? ((stat.to_f / total.to_f) * 100).to_i : 0
  end
end
# rubocop:enable Metrics/ClassLength
