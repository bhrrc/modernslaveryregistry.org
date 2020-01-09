class Legislation < ApplicationRecord
  has_many :legislation_statements, dependent: :restrict_with_exception
  has_many :statements, through: :legislation_statements

  validates :name, presence: true
  validates :icon, presence: true

  scope(:included_in_compliance_stats, -> { where(include_in_compliance_stats: true) })

  UK_NAME = 'UK Modern Slavery Act'.freeze
  CALIFORNIA_NAME = 'California Transparency in Supply Chains Act'.freeze
  AUS_NAME = 'Australia Modern Slavery Act'.freeze

  def requires_statement_attribute?(attribute)
    requires_statement_attributes.split(',').map(&:strip).include?(attribute.to_s)
  end
end
