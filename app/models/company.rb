class Company < ApplicationRecord
  has_many :statements,
           -> { Statement.reverse_chronological_order },
           dependent: :destroy,
           inverse_of: :company
  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :statements_from_other_companies, class_name: 'Statement'
  # rubocop:enable Rails/HasAndBelongsToMany
  belongs_to :country, optional: true
  belongs_to :industry, optional: true
  belongs_to :latest_statement_for_compliance_stats, class_name: 'Statement', optional: true

  validates :name, presence: true, uniqueness: true

  accepts_nested_attributes_for :statements, reject_if: :all_blank, allow_destroy: true

  def all_statements
    Statement.produced_by_or_associated_with(self).reverse_chronological_order
  end

  def latest_statement
    all_statements.first
  end

  def latest_published_statement
    published_statements.first
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
end
