class CompanySearchService
  def initialize(form)
    @form = form

    @where = []
    @where << { terms: { industry_id: form.industries } } if form.industries&.any?
    @where << { terms: { country_id: form.countries } } if form.countries&.any?
    @where << { terms: { legislation_ids: form.legislations } } if form.legislations&.any?
  end

  def perform
    if @form.statement_keywords.present?
      search_by_statement_keywords
    elsif @form.company_name.present? || @where.present?
      search_by_company_name_or_filters
    else
      search_all
    end
  end

  private

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

  def calculate_positive_query(statement_keyword = nil)
    result = []
    result << company_name_condition if @form.company_name.present?
    result << statement_keywords_condition(statement_keyword) if statement_keyword.present? && @form.include_keywords.presence == 'yes'
    result
  end

  def calculate_negative_query(statement_keyword = nil)
    result = []
    result << statement_keywords_condition(statement_keyword) if statement_keyword.present? && @form.include_keywords.presence == 'no'
    result
  end

  def search_by_statement_keywords
    @form.statement_keywords.map do |statement_keyword|
      positive_query = calculate_positive_query(statement_keyword)
      negative_query = calculate_negative_query(statement_keyword)

      conditions = { filter: @where }
      conditions.merge!(must: positive_query) if positive_query.present?
      conditions.merge!(must_not: negative_query) if negative_query.present?

      { statement_keyword => Company.search(body: { query: { bool: conditions } }) }
    end.inject(:merge)
  end

  def search_by_company_name_or_filters
    conditions = { filter: @where }
    conditions.merge!(must: calculate_positive_query)

    { '*' => Company.search(body: { query: { bool: conditions } }) }
  end

  def search_all
    { '*' => Company.search(body: { query: { match_all: {} } }) }
  end
end
