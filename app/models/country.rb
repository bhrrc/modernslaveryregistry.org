class Country < ApplicationRecord
  has_many :companies

  scope :with_companies, -> {
    joins(:companies).group('countries.id')
  }
end
