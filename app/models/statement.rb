require 'securerandom'
require 'uri'
require 'open-uri'
require 'timeout'
require 'csv'

class Statement < ApplicationRecord
  attr_accessor :contributor_email

  # Why optional: true
  # https://stackoverflow.com/questions/35942464/trouble-with-accepts-nested-attributes-for-in-rails-5-0-0-beta3-api-option/36254714#36254714
  belongs_to :company, optional: true

  belongs_to :verified_by, class_name: 'User', optional: true
  belongs_to :contributed_by, class_name: 'User'

  validates :url, presence: true
  validates :contributor_email, presence: true, unless: :contributed_by
  validates :link_on_front_page, inclusion: { in: [true, false] }, if: :verified?
  validates :approved_by_board,  inclusion: { in: ['Yes', 'No', 'Not explicit'] }, if: :verified?
  validates :signed_by_director, inclusion: { in: [true, false] }, if: :verified?

  before_create :set_date_seen
  before_validation(on: :create) do
    if self.contributed_by.nil?
      self.contributed_by = User.find_by_email(self.contributor_email) ||
        User.create!({
          email: self.contributor_email,
          first_name: self.contributor_email,
          password: SecureRandom.hex # Nobody will log in with this
        })
    end
  end

  scope :newest, -> {
    select("DISTINCT ON (statements.company_id) statements.*")
    .order(:company_id, date_seen: :desc)
  }

  scope :published, -> {
    where(published: true)
  }

  def self.search(current_user, query)
    statements = Statement.newest
    # Only display published statements - unless we're admin!
    statements = statements.published unless current_user && current_user.admin?
    statements = statements.includes(company: [:sector, :country])

    company_join = statements.joins(:company)
    if (query[:company_name] && !query[:company_name].empty?)
      company_join = company_join.where("LOWER(name) LIKE LOWER(?)", "%#{query[:company_name]}%")
      statements = company_join
    end
    if (query[:sectors])
      company_join = company_join.where(companies: {sector_id: query[:sectors]})
      statements = company_join
    end
    if (query[:countries])
      company_join = company_join.where(companies: {country_id: query[:countries]})
      statements = company_join
    end

    statements
  end

  def verified?
    !!verified_by
  end

  def country_name
    company.country.name rescue "Country unknown"
  end

  def sector_name
    company.sector.name rescue "Sector unknown"
  end

  # Tries to set the URL to https if possible - even if it was entered as http.
  # This is not only more secure, but it allows the site to display the statement
  # inside an iframe. Most browsers will block non-https iframes on an https site.
  def auto_update_url!
    # Some sites don't like non-browser user agents - pretend to be Chrome
    chrome = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36'

    uri = URI(self.url) rescue nil
    if uri.nil?
      self.broken_url = true
      return
    end
    begin
      uri.scheme = 'https'
      # The :read_timeout option for open-uri's open doesn't work with https,
      # only http.
      Timeout.timeout(3) { open(uri.to_s, {'User-Agent' => chrome}) }
      self.url = uri.to_s
      self.broken_url = false
    rescue => e
      begin
        uri.scheme = 'http'
        Timeout.timeout(3) { open(uri.to_s, {'User-Agent' => chrome}) }
        self.url = uri.to_s
        self.broken_url = false
      rescue => e
        # Set the statement URL to http, even though we haven't been able to
        # establish whether or not the url should be http or https.
        # It's more likely that http works than https.
        self.url = uri.to_s
        self.broken_url = true
      end
    end
  end

  def self.to_csv(statements)
    CSV.generate do |csv|
      csv << [
        'Company',
        'URL',
        'Sector',
        'HQ',
        'Date Added'
      ]
      statements.each do |statement|
        csv << [
          statement.company.name,
          statement.url,
          statement.sector_name,
          statement.country_name,
          statement.date_seen.iso8601
        ]
      end
    end
  end

  private

  before_save :auto_update_url! unless ENV['no_verify_statement_urls']

  def set_date_seen
    self.date_seen ||= Date.today
  end

  def set_contributor
    puts "Setting contributor: #{self.attributes}"
  end
end
