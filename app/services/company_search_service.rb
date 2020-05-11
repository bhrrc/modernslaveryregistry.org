class CompanySearchService
  def initialize(form)
    @form = form

    @where = []
    @where << { terms: { industry_id: form.industries } } if form.industries&.any?
    @where << { terms: { country_id: form.countries } } if form.countries&.any?
    @where << { terms: { legislation_ids: form.legislations } } if form.legislations&.any?
  end

  def perform
    companies = if searching_by_conditions?
      search_by_conditions
    else
      search_all
    end

    keyword_stats = calculate_keywords_stats(companies.total_count)

    {
      companies: companies,
      stats: {
        keywords: keyword_stats
      }
    }
  end

  def searching_by_conditions?
    [@form.statement_keywords, @form.company_name, @where].any?(&:present?)
  end

  def filtering_only_by_company_name?
    (@form.company_name&.present? && !@form.company_name.empty?) && 
        (@form.statement_keywords.nil? || @form.statement_keywords.empty?) && 
        (@where.nil? || @where.empty?)
  end

  def modern_slavery_act?
    return false unless @form.legislations.present? && !@form.legislations.empty?

    @msa ||= Legislation.find_by(name: "UK Modern Slavery Act")

    @form.legislations.include?(@msa.id.to_s)
  end

  private

  def calculate_keywords_stats(total_count)
    @form.statement_keywords&.map do |statement_keyword|
      conditions = calculate_conditions(Array.wrap(statement_keyword))
      result = Company.search(body: { query: { bool: conditions } }, load: false)
      {
        statement_keyword => {
          'mentioned': @form.include_keywords? ? result.total_count : total_count - result.total_count,
          'not_mentioned': @form.include_keywords? ? total_count - result.total_count : result.total_count,
        }
      }
    end&.inject(:merge)
  end

  def company_name_condition
    {
      bool: {
        should: [
          {
            dis_max: {
              queries: [
                {
                  match: {
                    'name.analyzed': {
                      query: @form.company_name,
                      boost: 10,
                      operator: 'and',
                      analyzer: 'searchkick_search'
                    }
                  }
                },
                {
                  match: {
                    'name.analyzed': {
                      query: @form.company_name,
                      boost: 10,
                      operator: 'and',
                      analyzer: 'searchkick_search2'
                    }
                  }
                },
                {
                  match: {
                    'name.analyzed': {
                      query: @form.company_name,
                      boost: 1,
                      operator: 'and',
                      analyzer: 'searchkick_search',
                      fuzziness: 1,
                      prefix_length: 0,
                      max_expansions: 3,
                      fuzzy_transpositions: true
                    }
                  }
                },
                {
                  match: {
                    'name.analyzed': {
                      query: @form.company_name,
                      boost: 1,
                      operator: 'and',
                      analyzer: 'searchkick_search2',
                      fuzziness: 1,
                      prefix_length: 0,
                      max_expansions: 3,
                      fuzzy_transpositions: true
                    }
                  }
                }
              ]
            }
          },
          {
            dis_max: {
              queries: [
                {
                  match: {
                    'related_companies.analyzed': {
                      query: @form.company_name,
                      boost: 10,
                      operator: 'and',
                      analyzer: 'searchkick_search'
                    }
                  }
                },
                {
                  match: {
                    'related_companies.analyzed': {
                      query: @form.company_name,
                      boost: 10,
                      operator: 'and',
                      analyzer: 'searchkick_search2'
                    }
                  }
                },
                {
                  match: {
                    'related_companies.analyzed': {
                      query: @form.company_name,
                      boost: 1,
                      operator: 'and',
                      analyzer: 'searchkick_search',
                      fuzziness: 1,
                      prefix_length: 0,
                      max_expansions: 3,
                      fuzzy_transpositions: true
                    }
                  }
                },
                {
                  match: {
                    'related_companies.analyzed': {
                      query: @form.company_name,
                      boost: 1,
                      operator: 'and',
                      analyzer: 'searchkick_search2',
                      fuzziness: 1,
                      prefix_length: 0,
                      max_expansions: 3,
                      fuzzy_transpositions: true
                    }
                  }
                }
              ]
            }
          }
        ]
      }
    }
  end

  def statement_keywords_condition(statement_keyword)
    {
      dis_max: {
        queries: [
          {
            match: {
              'statements.content.analyzed': {
                query: statement_keyword,
                boost: 10,
                operator: 'and',
                analyzer: 'searchkick_search'
              }
            }
          },
          {
            match: {
              'statements.content.analyzed': {
                query: statement_keyword,
                boost: 10,
                operator: 'and',
                analyzer: 'searchkick_search2'
              }
            }
          },
          {
            match: {
              'statements.content.analyzed': {
                query: statement_keyword,
                boost: 1,
                operator: 'and',
                analyzer: 'searchkick_search',
                fuzziness: 1,
                prefix_length: 0,
                max_expansions: 3,
                fuzzy_transpositions: true
              }
            }
          },
          {
            match: {
              'statements.content.analyzed': {
                query: statement_keyword,
                boost: 1,
                operator: 'and',
                analyzer: 'searchkick_search2',
                fuzziness: 1,
                prefix_length: 0,
                max_expansions: 3,
                fuzzy_transpositions: true
              }
            }
          }
        ]
      }
    }
  end

  def statement_keywords_conditions(statement_keywords)
    {
      bool: {
        should: statement_keywords.map { |statement_keyword| statement_keywords_condition(statement_keyword) }
      }
    }
  end

  def calculate_positive_query(statement_keywords)
    result = []
    result << company_name_condition if @form.company_name.present?
    result << statement_keywords_conditions(statement_keywords) if statement_keywords.present? && @form.include_keywords?
    result
  end

  def calculate_negative_query(statement_keywords)
    result = []
    result << statement_keywords_conditions(statement_keywords) if statement_keywords.present? && !@form.include_keywords?
    result
  end

  def calculate_conditions(statement_keywords)
    positive_query = calculate_positive_query(statement_keywords)
    negative_query = calculate_negative_query(statement_keywords)

    conditions = { filter: @where }
    conditions.merge!(must: positive_query) if positive_query.present?
    conditions.merge!(must_not: negative_query) if negative_query.present?
    conditions
  end

  def search_by_conditions
    conditions = calculate_conditions(@form.statement_keywords)
    Company.search({body: { query: { bool: conditions }, sort: { name: 'asc' }, track_total_hits: true }}.merge(limit_options))
  end

  def search_all
    Company.search({body: { query: { match_all: {} }, sort: { name: 'asc' }, track_total_hits: true }}.merge(limit_options))
  end

  def limit_options
    if @form.all
      { limit: Company::MAX_RESULT_WINDOW }
    else
      { page: @form.page, per_page: 20 }
    end
  end
end
