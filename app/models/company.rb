class Company < ApplicationRecord
  has_many :statements,
           -> { order(last_year_covered: :desc, date_seen: :desc) },
           dependent: :destroy,
           inverse_of: :company
  belongs_to :country, optional: true
  belongs_to :industry, optional: true

  validates :name, presence: true, uniqueness: true

  accepts_nested_attributes_for :statements, reject_if: :all_blank, allow_destroy: true

  def latest_statement
    statements.latest.first
  end

  def latest_published_statement
    published_statements.first
  end

  def published_statements
    statements.published
  end

  def country_name
    try(:country).try(:name) || 'Country unknown'
  end

  def industry_name
    try(:industry).try(:name) || 'Industry unknown'
  end

  def self.search(query)
    wild = "%#{query}%"
    Company.where(
      'lower(name) like lower(?)',
      wild
    )
  end

  def associate_all_statements_with_user(user)
    statements.each { |s| s.associate_with_user user }
  end

  def remove_blank_first_statement
    self.statements = [] if statements.first.present? && statements.first.url.blank?
  end

  def to_param
    [id, name.parameterize].join('-')
  end
end
