require 'uri'

class Statement < ApplicationRecord # rubocop:disable Metrics/ClassLength
  searchkick callbacks: :async, deep_paging: true, batch_size: 200

  def search_data
    {
      company_ids: Company.where(latest_statement_for_compliance_stats_id: id).map(&:id),
      uk_modern_slavery_act: uk_modern_slavery_act?,
      link_on_front_page: link_on_front_page?,
      signed_by_director: signed_by_director?,
      approved_by_board: approved_by_board == 'Yes',
      fully_compliant: fully_compliant?
    }
  end

  # Why optional: true
  # https://stackoverflow.com/questions/35942464/trouble-with-accepts-nested-attributes-for-in-rails-5-0-0-beta3-api-option/36254714#36254714
  belongs_to :company, optional: true
  belongs_to :verified_by, class_name: 'User', optional: true
  has_one :snapshot, dependent: :destroy
  has_many :legislation_statements, dependent: :destroy
  has_many :legislations, through: :legislation_statements
  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :additional_companies_covered,
                          class_name: 'Company',
                          after_add: :update_latest_statement_for_compliance_stats_for_other_company,
                          after_remove: :update_latest_statement_for_compliance_stats_for_other_company
  # rubocop:enable Rails/HasAndBelongsToMany

  has_and_belongs_to_many :additional_companies_covered_ordered_by_name,
                          -> { order(:name) },
                          class_name: 'Company'

  validates :url, presence: true, url_format: true
  validates :link_on_front_page, boolean: true, if: -> { legislation_requires?(:link_on_front_page) }
  validates :approved_by_board, yes_no_not_explicit: true, if: -> { legislation_requires?(:approved_by_board) }
  validates :signed_by_director, boolean: true, if: -> { legislation_requires?(:signed_by_director) }

  before_create { self.date_seen ||= Time.zone.today }
  after_save :enqueue_snapshot unless ENV['no_fetch']
  after_commit :perform_snapshot_job

  after_save :update_latest_statement_for_compliance_stats
  after_destroy :update_latest_statement_for_compliance_stats

  scope(:reverse_chronological_order, -> { order('last_year_covered DESC NULLS LAST', date_seen: :desc) })
  scope(:included_in_compliance_stats, -> { joins(:legislations).merge(Legislation.included_in_compliance_stats) })
  scope(:published, -> { where(published: true) })
  scope(:most_recently_published, -> { published.order('created_at DESC').limit(20) })
  scope(:approved_by_board, -> { where(approved_by_board: 'Yes') })
  scope(:link_on_front_page, -> { where(link_on_front_page: true) })
  scope(:signed_by_director, -> { where(signed_by_director: true) })
  scope(:fully_compliant, -> { approved_by_board.link_on_front_page.signed_by_director })
  scope(:with_content_extracted, -> { where(content_extracted: true) })

  scope :produced_by_or_associated_with, lambda { |company|
    left_outer_joins(:additional_companies_covered)
      .where('statements.company_id = ? OR companies_statements.company_id = ?', company.id, company.id)
      .distinct
  }

  delegate :country_name, :industry_name, to: :company

  attr_accessor :should_enqueue_snapshot

  after_commit :reindex_company

  def reindex_company
    company&.reindex
  end

  def self.url_exists?(url)
    uri = URI(url)
    uri.scheme = 'https'
    return true if exists?(url: uri.to_s)

    uri.scheme = 'http'
    exists?(url: uri.to_s)
  end

  def self.bulk_create!(company_name, statement_url, legislation_name)
    return if Statement.url_exists?(statement_url)

    begin
      company = Company.find_or_create_by!(name: company_name)
      legislation = Legislation.find_by(name: legislation_name)
      statement = company.statements.create!(url: statement_url)
      statement.legislations << legislation
    rescue ActiveRecord::RecordInvalid => e
      e.message += "\nCompany Name: '#{company_name}', Statement URL: '#{statement_url}'"
      raise e
    end
  end

  def published_by?(company)
    self.company == company
  end

  def additional_companies_covered_excluding(company)
    additional_companies_covered_ordered_by_name - [company]
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
    contributor_email.presence || verified_by_email
  end

  def enqueue_snapshot
    @should_enqueue_snapshot = true if saved_change_to_url? || saved_change_to_marked_not_broken_url?
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

    return if broken_url

    build_snapshot_from_result(fetch_result)
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

  def uk_modern_slavery_act?
    legislations.any? { |legislation| legislation.name == Legislation::UK_NAME }
  end

  def california_transparency_in_supply_chains_act?
    legislations.any? { |legislation| legislation.name == Legislation::CALIFORNIA_NAME }
  end

  def aus_modern_slavery_act?
    legislations.any? { |legislation| legislation.name == Legislation::AUS_NAME }
  end

  def latest_for?(company)
    self == company.latest_statement
  end

  def also_covers_companies
    additional_companies_covered.map(&:name)
  end

  def also_covered?
    !additional_companies_covered.empty?
  end

  def also_covered_and_published_by?(company)
    if self.company == company
      false
    else
      !additional_companies_covered.empty?
    end
  end

  def should_use_override_url?
    !override_url.blank?
  end

  def preview_url
    override_url || url
  end

  def extract_content_from_statement
    # Don't want to trigger callbacks so that we can seperate indexing and content extraction
    if snapshot
      extracted_text = Henkei.read(:text, snapshot.original.download)
      update_columns(content_text: extracted_text.truncate(30000, separator: ' '), content_extracted: true)

      # reindex associated companies
      company.reindex
      additional_companies_covered.reindex
    end
  end

  private

  def legislation_requires?(attribute)
    published? && legislations.any? { |legislation| legislation.requires_statement_attribute?(attribute) }
  end

  def company_name(company = self.company)
    company.name
  end

  def company_number(company = self.company)
    company.company_number
  end

  def build_snapshot_from_result(fetch_result)
    build_snapshot
    snapshot.original.attach(
      io: StringIO.new(fetch_result.content_data),
      filename: 'original',
      content_type: fetch_result.content_type
    )
    attach_screenshot_to_snapshot(snapshot)
  end

  def attach_screenshot_to_snapshot(snapshot)
    return unless snapshot.original_is_html?

    image_fetch_result = ScreenGrab.fetch(url)
    return if image_fetch_result.broken_url

    snapshot.screenshot.attach(
      io: StringIO.new(image_fetch_result.content_data),
      filename: 'screenshot.png',
      content_type: image_fetch_result.content_type
    )
  end

  def update_latest_statement_for_compliance_stats_for_other_company(other_company = nil)
    latest_statement_for_compliance_stats = other_company.published_statements.included_in_compliance_stats.first
    other_company.update(latest_statement_for_compliance_stats: latest_statement_for_compliance_stats)
  end

  def update_latest_statement_for_compliance_stats
    latest_statement_for_compliance_stats = company.published_statements.included_in_compliance_stats.first
    company.update(latest_statement_for_compliance_stats: latest_statement_for_compliance_stats)
  end
end
