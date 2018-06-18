class Legislation < ApplicationRecord
  has_many :legislation_statements, dependent: :restrict_with_exception
  has_many :statements, through: :legislation_statements

  scope(:included_in_compliance_stats, -> { where(include_in_compliance_stats: true) })

  def requires_statement_attribute?(attribute)
    requires_statement_attributes.split(',').map(&:strip).include?(attribute.to_s)
  end
end
