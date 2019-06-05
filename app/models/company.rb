class Company < ApplicationRecord
  has_many :statements,
           -> { Statement.reverse_chronological_order },
           dependent: :destroy,
           inverse_of: :company
  belongs_to :country, optional: true
  belongs_to :industry, optional: true
  belongs_to :latest_statement_for_compliance_stats, class_name: 'Statement', optional: true

  validates :name, presence: true, uniqueness: true
  validates :company_number, uniqueness: true, allow_blank: true
  validates :company_number, presence: true, if: :required_country?

  accepts_nested_attributes_for :statements, reject_if: :all_blank, allow_destroy: true

  scope :with_associated_published_statements_in_legislation, lambda { |legislation_name|
    joins('INNER JOIN companies_statements ON companies_statements.company_id = companies.id')
      .joins('INNER JOIN statements ON statements.id = companies_statements.statement_id')
      .joins('INNER JOIN legislation_statements ON legislation_statements.statement_id = statements.id')
      .joins('INNER JOIN legislations ON legislations.id = legislation_statements.legislation_id')
      .merge(Statement.published)
      .where('legislations.name = ?', legislation_name)
      .distinct
  }

  def all_statements
    Statement.produced_by_or_associated_with(self).reverse_chronological_order
  end

  def latest_statement
    all_statements.first
  end

  def latest_published_statement
    published_statements.reverse_chronological_order.first
  end

  def published_statements
    all_statements.published
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

  def required_country?
    if country&.name == 'United Kingdom' && ['Public Entities', 'Charity/Non-Profit'].exclude?(industry&.name)
      true
    else
      false
    end
  end
end
