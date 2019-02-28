class IndustryGroupCounts
  class NullIndustry
    def name
      'Industry unknown'
    end
  end

  def initialize(results)
    @results = results
  end

  def stats
    groups.sort_by(&:count).reverse
  end

  private

  def counts
    @results.pluck(:industry_id).each_with_object(Hash.new(0)) do |id, count|
      count[id] += 1
    end
  end

  def groups
    groups = Industry.where(id: counts.keys).each_with_object([]) do |industry, array|
      array << GroupCount.with(group: industry, count: counts[industry.id])
    end
    groups << GroupCount.with(group: NullIndustry.new, count: @results.where(industry_id: nil).count)
    groups
  end
end
