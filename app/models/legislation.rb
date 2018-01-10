class Legislation < ApplicationRecord
  def requires_statement_attribute?(attribute)
    requires_statement_attributes.split(',').map(&:strip).include?(attribute.to_s)
  end
end
