require 'securerandom'
require 'uri'
require 'open-uri'
require 'timeout'
require 'csv'

class Statement < ApplicationRecord
  # Why optional: true
  # https://stackoverflow.com/questions/35942464/trouble-with-accepts-nested-attributes-for-in-rails-5-0-0-beta3-api-option/36254714#36254714
  belongs_to :company, optional: true

  belongs_to :verified_by, class_name: 'User', optional: true

  validates :url, presence: true
  validates :link_on_front_page, inclusion: { in: [true, false] }, if: :verified?
  validates :approved_by_board,  inclusion: { in: ['Yes', 'No', 'Not explicit'] }, if: :verified?
  validates :signed_by_director, inclusion: { in: [true, false] }, if: :verified?

  before_create :set_date_seen

  scope(:newest, lambda {
    select('DISTINCT ON (statements.company_id) statements.*')
      .order(:company_id, date_seen: :desc)
  })

  scope(:published, -> { where(published: true) })

  def self.search(admin:, criteria:)
    StatementSearch.new(admin, criteria)
  end

  def associate_with_user(user)
    self.verified_by = published? ? user : nil
    self.contributor_email ||= user && user.email
  end

  def verified?
    verified_by.present?
  end

  def country_name
    company.country.name
  rescue
    'Country unknown'
  end

  def sector_name
    company.sector.name
  rescue
    'Sector unknown'
  end

  def verified_by_email
    verified_by.email
  rescue
    nil
  end

  def self.to_csv(statements, extra)
    fields = BASIC_EXPORT_FIELDS.merge(extra ? EXTRA_EXPORT_FIELDS : {})
    CSV.generate do |csv|
      csv << fields.map { |_, heading| heading }
      statements.each do |statement|
        csv << fields.map { |name, _| format_for_csv(statement.send(name)) }
      end
    end
  end

  def self.format_for_csv(value)
    value.respond_to?(:iso8601) ? value.iso8601 : value
  end

  private

  BASIC_EXPORT_FIELDS = {
    company_name: 'Company',
    url: 'URL',
    sector_name: 'Sector',
    country_name: 'HQ',
    date_seen: 'Date Added'
  }.freeze

  EXTRA_EXPORT_FIELDS = {
    approved_by_board: 'Approved by Board',
    approved_by: 'Approved by',
    signed_by_director: 'Signed by Director',
    signed_by: 'Signed by',
    link_on_front_page: 'Link on Front Page',
    published: 'Published',
    verified_by_email: 'Verified by',
    contributor_email: 'Contributed by',
    broken_url: 'Broken URL'
  }.freeze

  def company_name
    company.name
  end

  before_save :fetch_statement_from_url! unless ENV['no_fetch']

  def set_date_seen
    self.date_seen ||= Time.zone.today
  end

  def fetch_statement_from_url!
    assign_attributes StatementUrl.fetch(url).to_h
  end
end
