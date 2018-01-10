class Statement < ApplicationRecord
  # Why optional: true
  # https://stackoverflow.com/questions/35942464/trouble-with-accepts-nested-attributes-for-in-rails-5-0-0-beta3-api-option/36254714#36254714
  belongs_to :company, optional: true
  belongs_to :verified_by, class_name: 'User', optional: true
  has_one :snapshot, dependent: :destroy
  has_many :legislation_statements, dependent: :destroy
  has_many :legislations, through: :legislation_statements

  validates :url, presence: true, url_format: true
  validates :link_on_front_page, boolean: true, if: -> { legislation_requires?(:link_on_front_page) }
  validates :approved_by_board, yes_no_not_explicit: true, if: -> { legislation_requires?(:approved_by_board) }
  validates :signed_by_director, boolean: true, if: -> { legislation_requires?(:signed_by_director) }

  before_create { self.date_seen ||= Time.zone.today }
  after_save :enqueue_snapshot unless ENV['no_fetch']
  after_commit :perform_snapshot_job
  after_save :mark_latest
  after_save :mark_latest_published

  scope(:published, -> { where(published: true) })
  scope(:latest, -> { where(latest: true) })
  scope(:latest_published, -> { where(latest_published: true) })

  delegate :country_name, :sector_name, to: :company

  attr_accessor :should_enqueue_snapshot

  def self.search(include_unpublished:, criteria:)
    StatementSearch.new(include_unpublished, criteria)
  end

  def associate_with_user(user)
    self.verified_by ||= user if user.admin? && published?
    self.contributor_email = user && user.email if contributor_email.blank?
  end

  def fully_compliant?
    approved_by_board == 'Yes' && link_on_front_page? && signed_by_director?
  end

  def verified_by_email
    try(:verified_by).try(:email)
  end

  def contributor_or_verifier_email
    contributor_email.blank? ? verified_by_email : contributor_email
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

  def previewable_snapshot?
    snapshot.present? && snapshot.previewable?
  end

  def year_covered=(array_of_years)
    self.first_year_covered = array_of_years.map(&:to_i).min
    self.last_year_covered = array_of_years.map(&:to_i).max
  end

  def period_covered
    [first_year_covered, last_year_covered].uniq.join('-')
  end

  def period_covered=(period)
    years = period.split('-').map(&:to_i)
    self.first_year_covered = years[0]
    self.last_year_covered = years[1]
  end

  private

  def legislation_requires?(attribute)
    published? && legislations.any? { |legislation| legislation.requires_statement_attribute?(attribute) }
  end

  def company_name
    company.name
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
