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
  has_one :snapshot, dependent: :destroy

  validates :url, presence: true
  validates :link_on_front_page, inclusion: { in: [true, false] }, if: :verified?
  validates :approved_by_board,  inclusion: { in: ['Yes', 'No', 'Not explicit'] }, if: :verified?
  validates :signed_by_director, inclusion: { in: [true, false] }, if: :verified?

  before_create :set_date_seen
  after_save :mark_latest
  after_save :mark_latest_published

  scope(:latest, -> { where(latest: true) })
  scope(:latest_published, -> { where(latest_published: true) })

  scope(:published, -> { where(published: true) })

  delegate :country_name, to: :company
  delegate :sector_name, to: :company

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

  def fully_compliant?
    approved_by_board == 'Yes' && link_on_front_page? && signed_by_director?
  end

  def verified_by_email
    try(:verified_by).try(:email)
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
    fetch_result = StatementUrl.fetch(url)
    self.url = fetch_result.url
    self.broken_url = fetch_result.broken_url
    build_snapshot_from_result(fetch_result) unless broken_url
  end

  def build_snapshot_from_result(fetch_result)
    image_fetch_result = fetch_result.content_type =~ /pdf/ ? nil : ScreenGrab.fetch(url)
    self.snapshot = Snapshot.new(
      content_type: fetch_result.content_type,
      content_data: fetch_result.content_data,
      image_content_type: image_fetch_result && image_fetch_result.content_type,
      image_content_data: image_fetch_result && image_fetch_result.content_data
    )
  end

  # rubocop:disable Rails/SkipsModelValidations
  def mark_latest
    company.statements.update_all(latest: false)
    company.statements.order(date_seen: :desc).limit(1).update_all(latest: true)
  end

  def mark_latest_published
    return unless published?
    company.statements.update_all(latest_published: false)
    company.statements.published.order(date_seen: :desc).limit(1).update_all(latest_published: true)
  end
  # rubocop:enable Rails/SkipsModelValidations
end
