require 'securerandom'
require 'uri'
require 'open-uri'
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

  unless ENV['no_verify_statement_urls']
    before_save do |statement|
      uri = URI(statement.url) rescue nil
      if uri.nil?
        statement.broken_url = true
        break
      end
      begin
        uri.scheme = 'https'
        open(uri, read_timeout: 10)
        statement.url = uri.to_s
        statement.broken_url = false
      rescue
        begin
          uri.scheme = 'http'
          open(uri, read_timeout: 10)
          statement.url = uri.to_s
          statement.broken_url = false
        rescue
          statement.broken_url = true
        end
      end
    end
  end

  def set_date_seen
    self.date_seen ||= Date.today
  end

  def set_contributor
    puts "Setting contributor: #{self.attributes}"
  end
end
