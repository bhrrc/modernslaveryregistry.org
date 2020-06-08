class CompanySearchService
  def initialize(form)
    @form = form

    @where = []
    @where << { terms: { industry_id: form.industries } } if form.industries&.any?
    @where << { terms: { country_id: form.countries } } if form.countries&.any?
    @where << { terms: { legislation_ids: form.legislations } } if form.legislations&.any?
  end

  def results
    @result ||= if searching_by_conditions?
      search_by_conditions
    else
      search_all
    end
  end

  def stats
    @stats ||=  {
      keywords: calculate_keywords_stats,
      uk_requirements: calculate_uk_requirements_stats
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
    return true if !@form.legislations.present? || @form.legislations.empty?

    @msa ||= Legislation.find_by(name: "UK Modern Slavery Act")

    @form.legislations.include?(@msa.id.to_s)
  end

  private

  def calculate_uk_requirements_stats
    company_ids = if searching_by_conditions?
      search_by_conditions(true)
    else
      search_all(true)
    end&.map(&:id)

    statements = Statement.search({body: { "_source": false, query: { bool: { filter: { terms: { company_ids: company_ids } } } }, aggs: aggregations, track_total_hits: true }, limit: Company::MAX_RESULT_WINDOW})

    uk_modern_slavery_act_count = statements.aggregations.dig('uk_modern_slavery_act', 'uk_modern_slavery_act', 'count')
    statements.aggregations.map do |field, data|
      field_count = data.dig(field, 'count')
      {
        field.to_sym => {
          count: field_count,
          percent: (field_count.to_f / uk_modern_slavery_act_count.to_f * 100).to_i
        }
      }
    end&.inject(:merge)
  end

  def calculate_keywords_stats
    @form.statement_keywords&.map do |statement_keyword|
      conditions = calculate_conditions(Array.wrap(statement_keyword))
      result = Company.search(body: { query: { bool: conditions } }, load: false)
      {
        statement_keyword => {
          'mentioned': @form.include_keywords? ? result.total_count : results.total_count - result.total_count,
          'not_mentioned': @form.include_keywords? ? results.total_count - result.total_count : result.total_count,
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
            match_phrase: {
              'statements.content.analyzed': {
                query: statement_keyword,
                boost: 10,
                analyzer: 'searchkick_search'
              }
            }
          },
          {
            match_phrase: {
              'statements.content.analyzed': {
                query: statement_keyword,
                boost: 10,
                analyzer: 'searchkick_search2'
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
        should: statement_keywords.map { |statement_keyword| wrap_statement_condition(statement_keywords_condition(statement_keyword)) }
      }
    }
  end

  def wrap_statement_condition(condition)
    if @form.include_keywords?
      condition
    else
      { bool: { must_not: condition } }
    end
  end

  AGGS_FIELDS = %i[uk_modern_slavery_act link_on_front_page signed_by_director approved_by_board fully_compliant].freeze

  def aggregate_query(field)
    {
      filter: {
        term: {
          field => true
        }
      },
      aggs: {
        field => {
          stats: {
            field: field.to_s
          }
        }
      }
    }
  end

  def aggregations
    AGGS_FIELDS.map { |field| { field => aggregate_query(field) } }&.inject(:merge)
  end

  def calculate_query(statement_keywords)
    result = []
    result << company_name_condition if @form.company_name.present?
    result << statement_keywords_conditions(statement_keywords) if statement_keywords.present?
    result
  end

  def calculate_conditions(statement_keywords)
    query = calculate_query(statement_keywords)

    conditions = { filter: @where }
    conditions.merge!(must: query) if query.present?
    conditions
  end

  def search_by_conditions(force_all_records = false)
    conditions = calculate_conditions(@form.statement_keywords)
    Company.search({body: { "_source": false, query: { bool: conditions }, sort: { name: 'asc' }, track_total_hits: true }}.merge(limit_options(force_all_records)))
  end

  def search_all(force_all_records = false)
    Company.search({body: { "_source": false, query: { match_all: {} }, sort: { name: 'asc' }, track_total_hits: true }}.merge(limit_options(force_all_records)))
  end

  def limit_options(force_all_records)
    if @form.fetch_all_records? || force_all_records
      { limit: Company::MAX_RESULT_WINDOW }
    else
      { page: @form.page, per_page: 20 }
    end
  end
end
