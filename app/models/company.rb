class Company < ApplicationRecord
  has_many :statements, dependent: :destroy
  belongs_to :country, optional: true
  belongs_to :sector, optional: true

  validates :name, presence: true

  accepts_nested_attributes_for :statements, reject_if: :all_blank, allow_destroy: true

  def latest_statement
    statements.latest.first
  end

  def country_name
    try(:country).try(:name) || 'Country unknown'
  end

  def sector_name
    try(:sector).try(:name) || 'Sector unknown'
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
