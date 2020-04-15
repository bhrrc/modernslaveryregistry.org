class CompanySearchForm
  KEYWORD_VALUES = [
    'human rights due diligence',
    'UN Guiding Principles',
    'ILO',
    'social audits',
    'grievance mechanism',
    'remedy',
    'sourcing country',
    'commodities',
    'trade union',
    'collective bargaining',
    'freedom of association',
    'recruitment fees',
    'recruitment agencies',
    'labour agencies',
    'child labour',
    'migrant',
    'bonded',
    'seasonal',
    'living wage',
    'tier',
    'mapping',
    'working conditions'
  ].freeze
  INCLUDE_KEYWORDS_VALUE = 'yes'.freeze
  EXCLUDE_KEYWORDS_VALUE = 'no'.freeze

  attr_reader :company_name, :statement_keywords, :include_keywords, :industries, :countries, :legislations, :page

  def initialize(params = {})
    @company_name = params.fetch(:company_name, nil).presence
    @statement_keywords = params.fetch(:statement_keywords, nil).presence&.split(',')&.map(&:strip)
    # TODO: include_keywords - default value
    @include_keywords = (params.fetch(:include_keywords, nil).presence || INCLUDE_KEYWORDS_VALUE) == INCLUDE_KEYWORDS_VALUE

    @industries = params.fetch(:industries, nil).presence
    @countries = params.fetch(:countries, nil).presence
    @legislations = params.fetch(:legislations, nil).presence

    @page = params.fetch(:page, nil) || 1
  end

  def include_keywords?
    include_keywords
  end
end
