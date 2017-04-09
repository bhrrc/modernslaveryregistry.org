class Country < ApplicationRecord
  has_many :companies

  scope :with_companies, -> {
    joins(:companies).group('countries.id')
  }

  scope :with_company_counts, -> {
    select <<~SQL
      countries.*,
      (
        SELECT COUNT(companies.id) FROM companies
        WHERE country_id = countries.id
      ) AS company_count
    SQL
  }
end
