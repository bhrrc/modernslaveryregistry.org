module ExploreHelper
  def display_filtering_by_company_name?
    params[:company_name].present? && !params[:company_name].empty?
  end

  def display_sidebar_below_threshold?
    return false if display_filtering_by_company_name?

    @results.total_count < 5
  end

  def display_sidebar_only_modern_slavery?
    return false if display_sidebar_below_threshold?
    return false if display_filtering_by_company_name?

    !@search.modern_slavery_act? && @search.searching_by_conditions?
  end

  def display_sidebar_keyword_mentions?
    return false if display_sidebar_only_modern_slavery?

    @results.any? && @search.stats[:keywords]
  end

  def display_sidebar_risks_industry?
    return false if display_sidebar_below_threshold?
    return false if display_filtering_by_company_name?

    # not implemented in backend search
    false
  end

  def display_statement_stats?
    return false if display_sidebar_below_threshold?
    return false if display_sidebar_only_modern_slavery?
    return false if display_filtering_by_company_name?

    true
  end

  def options_for_statement_keywords
    options = [["Suggested keywords", CompanySearchForm::KEYWORD_VALUES.map { |k| [I18n.t("explore.statement_keywords.#{k}"), k] }]]

    return options if params[:statement_keywords].nil?

    custom_keywords = params[:statement_keywords] - CompanySearchForm::KEYWORD_VALUES

    options << ["", custom_keywords] unless custom_keywords.empty?

    options
  end
end