module ExploreHelper
  def display_sidebar_below_threshold?
    @results.length < 5
  end

  def display_sidebar_only_modern_slavery?
    return false if display_sidebar_below_threshold?

    !@search.modern_slavery_act? && @search.searching_by_conditions?
  end

  def display_sidebar_keyword_mentions?
    return false if display_sidebar_only_modern_slavery?

    @results.any? && @search.stats[:keywords]
  end

  def display_sidebar_risks_industry?
    return false if display_sidebar_below_threshold?
    return false if display_sidebar_below_threshold?

    # not implemented in backend search
    false
  end

  def display_statement_stats?
    return false if display_sidebar_below_threshold?
    return false if display_sidebar_only_modern_slavery?

    true
  end
end