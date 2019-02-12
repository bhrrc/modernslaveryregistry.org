class ComplianceStats
  def initialize(counts, total)
    @counts = counts
    @total = total
  end

  def self.compile
    total = 0
    counts = { approved_by_board: 0, link_on_front_page?: 0, signed_by_director?: 0, fully_compliant?: 0 }
    Statement.latest_published.joins(:legislations).merge(Legislation.included_in_compliance_stats).each do |statement|
      counts.keys.each do |key|
        counts[key] += 1 if [true, 'Yes'].include? statement.send(key)
      end
      total += 1
    end
    ComplianceStats.new(counts, total)
  end

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
