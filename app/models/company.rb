class Company < ApplicationRecord
  has_many :statements
  has_one :country
  has_one :sector
end
