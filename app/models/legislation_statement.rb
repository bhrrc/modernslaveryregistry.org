class LegislationStatement < ApplicationRecord
  belongs_to :legislation, inverse_of: :legislation_statements
  belongs_to :statement, inverse_of: :legislation_statements
end
