class Sector < ApplicationRecord
  has_many :companies
  has_many :countries, -> { distinct }, through: :companies

  scope :with_companies, -> {
    joins(:companies).group('sectors.id')
    #left_outer_joins(:companies).group(:id).order('COUNT(companies.id) DESC')
  }

  scope :with_company_counts, -> {
    select <<~SQL
      sectors.*,
      (
        SELECT COUNT(companies.id) FROM companies
        WHERE sector_id = sectors.id
      ) AS company_count
    SQL
  }
end
