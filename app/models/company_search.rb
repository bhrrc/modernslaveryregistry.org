class CompanySearch
  def initialize(options = {})
    @company_name = options.fetch(:company_name, nil)
    @statement_keywords = options.fetch(:statement_keywords, nil)
    # TODO: include_keywords - default value
    @include_keywords = options.fetch(:include_keywords, 'yes')

    industries = options.fetch(:industries, nil)
    countries = options.fetch(:countries, nil)
    legislations = options.fetch(:legislations, nil)
    @where = []
    @where << { terms: { industry_id: industries } } if industries&.any?
    @where << { terms: { country_id: countries } } if countries&.any?
    @where << { terms: { legislation_ids: legislations } } if legislations&.any?
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
                      query: @company_name,
                      boost: 10,
                      operator: 'and',
                      analyzer: 'searchkick_search'
                    }
                  }
                },
                {
                  match: {
                    'name.analyzed': {
                      query: @company_name,
                      boost: 10,
                      operator: 'and',
                      analyzer: 'searchkick_search2'
                    }
                  }
                },
                {
                  match: {
                    'name.analyzed': {
                      query: @company_name,
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
                      query: @company_name,
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
                      query: @company_name,
                      boost: 10,
                      operator: 'and',
                      analyzer: 'searchkick_search'
                    }
                  }
                },
                {
                  match: {
                    'related_companies.analyzed': {
                      query: @company_name,
                      boost: 10,
                      operator: 'and',
                      analyzer: 'searchkick_search2'
                    }
                  }
                },
                {
                  match: {
                    'related_companies.analyzed': {
                      query: @company_name,
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
                      query: @company_name,
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

  def statement_keywords_condition
    {
      dis_max: {
        queries: [
          {
            match: {
              'statements.content.analyzed': {
                query: @statement_keywords,
                boost: 10,
                operator: 'and',
                analyzer: 'searchkick_search'
              }
            }
          },
          {
            match: {
              'statements.content.analyzed': {
                query: @statement_keywords,
                boost: 10,
                operator: 'and',
                analyzer: 'searchkick_search2'
              }
            }
          },
          {
            match: {
              'statements.content.analyzed': {
                query: @statement_keywords,
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
                query: @statement_keywords,
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

  def calculate_positive_query
    result = []
    result << company_name_condition if @company_name.present?
    result << statement_keywords_condition if @statement_keywords.present? && @include_keywords.presence == 'yes'
    result
  end

  def calculate_negative_query
    result = []
    result << statement_keywords_condition if @statement_keywords.present? && @include_keywords.presence == 'no'
    result
  end

  def results
    positive_query = calculate_positive_query
    negative_query = calculate_negative_query
    if [positive_query, negative_query, @where].any?(&:present?)
      conditions = { filter: @where }
      conditions.merge!(must: positive_query) if positive_query.present?
      conditions.merge!(must_not: negative_query) if negative_query.present?

      Company.search(body: { query: { bool: conditions } })
    else
      Company.search(body: { query: { match_all: {} } })
    end
  end

  def statement_count_for(company)
    return company.published_statements.count if @legislations.blank?

    company.published_statements.joins(:legislations).where(legislations: { id: @legislations }).count
  end
end
