class ComplianceStats
  attr_reader :industry

  def initialize(industry: false)
    @statements = Statement
                  .joins('INNER JOIN companies ON statements.id = companies.latest_statement_for_compliance_stats_id')
    @statements = @statements.merge(Company.where(industry: industry)) if industry
  end

  def total
    @total ||= @statements.count
  end

  def approved_by_board_count
    @approved_by_board_count ||= @statements.approved_by_board.count
  end

  def link_on_front_page_count
    @link_on_front_page_count ||= @statements.link_on_front_page.count
  end

  def signed_by_director_count
    @signed_by_director_count ||= @statements.signed_by_director.count
  end

  def fully_compliant_count
    @fully_compliant_count ||= @statements.fully_compliant.count
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
