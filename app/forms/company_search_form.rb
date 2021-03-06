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

  attr_reader :company_name, :statement_keywords, :include_keywords, :industries, :countries, :legislations, :page, :fetch_all_records

  def initialize(params = {})
    @company_name = params.fetch(:company_name, nil).presence
    @statement_keywords = params.fetch(:statement_keywords, nil).presence&.map(&:strip)
    # TODO: include_keywords - default value
    @include_keywords = (params.fetch(:include_keywords, nil).presence || INCLUDE_KEYWORDS_VALUE) == INCLUDE_KEYWORDS_VALUE

    @industries = cleanup_ids(params.fetch(:industries, [])).presence
    @countries = cleanup_ids(params.fetch(:countries, [])).presence
    @legislations = cleanup_ids(params.fetch(:legislations, [])).presence

    @page = params.fetch(:page, nil) || 1
    @fetch_all_records = params.fetch(:fetch_all_records, nil) || false
  end

  def include_keywords?
    include_keywords
  end

  def fetch_all_records?
    fetch_all_records
  end

  private

  def cleanup_ids(ids)
    ids ||= []
    ids.map { |id| id.to_s.gsub(/\D+/, '').presence }.compact.map(&:to_i)
  end
end
