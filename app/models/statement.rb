require 'securerandom'
require 'uri'
require 'open-uri'
require 'timeout'

class Statement < ApplicationRecord
  # Why optional: true
  # https://stackoverflow.com/questions/35942464/trouble-with-accepts-nested-attributes-for-in-rails-5-0-0-beta3-api-option/36254714#36254714
  belongs_to :company, optional: true

  belongs_to :verified_by, class_name: 'User', optional: true
  has_one :snapshot, dependent: :destroy

  validates :url, presence: true
  validates_with UrlFormatValidator
  validates :link_on_front_page, inclusion: { in: [true, false] }, if: :verified?
  validates :approved_by_board,  inclusion: { in: ['Yes', 'No', 'Not explicit'] }, if: :verified?
  validates :signed_by_director, inclusion: { in: [true, false] }, if: :verified?

  before_create :set_date_seen
  after_save :enqueue_snapshot unless ENV['no_fetch']
  after_commit :perform_snapshot_job
  after_save :mark_latest
  after_save :mark_latest_published

  scope(:latest, -> { where(latest: true) })
  scope(:latest_published, -> { where(latest_published: true) })

  scope(:published, -> { where(published: true) })

  delegate :country_name, to: :company
  delegate :sector_name, to: :company

  attr_accessor :should_enqueue_snapshot

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
    StatementExport.to_csv(statements, extra)
  end

  def enqueue_snapshot
    @should_enqueue_snapshot = true if url_changed? || marked_not_broken_url_changed?
  end

  def perform_snapshot_job
    return unless @should_enqueue_snapshot
    FetchStatementSnapshotJob.perform_later(id)
    @should_enqueue_snapshot = false
  end

  def fetch_snapshot
    fetch_result = StatementUrl.fetch(url)
    self.url = fetch_result.url
    self.broken_url = fetch_result.broken_url
    build_snapshot_from_result(fetch_result) unless broken_url && !marked_not_broken_url?
  end

  private

  def company_name
    company.name
  end

  def set_date_seen
    self.date_seen ||= Time.zone.today
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
