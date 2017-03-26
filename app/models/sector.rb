class Sector < ApplicationRecord
  has_many :companies

  scope :with_companies, -> {
    joins(:companies).group('sectors.id')
  }
end
