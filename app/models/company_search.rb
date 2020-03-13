class CompanySearch
  def initialize(company_name: nil, statement_keywords: nil, industries: [], countries: [], legislations: [])
    @company_name = company_name
    @statement_keywords = statement_keywords

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

  def calculate_query
    result = []
    result << company_name_condition if @company_name.present?
    result << statement_keywords_condition if @statement_keywords.present?
    result
  end

  def results
    query = calculate_query
    if query.present? || @where.present?
      Company.search(body: { query: { bool: { must: query, filter: @where } } })
    else
      Company.search(body: { query: { match_all: {} } })
    end
  end

  def statement_count_for(company)
    return company.published_statements.count if @legislations.blank?

    company.published_statements.joins(:legislations).where(legislations: { id: @legislations }).count
  end
end
