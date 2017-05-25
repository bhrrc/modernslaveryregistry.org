class Country < ApplicationRecord
  has_many :companies

  scope(:with_companies, lambda {
    joins(:companies).group('countries.id')
  })

  scope(:with_company_counts, lambda {
    select <<~SQL
      countries.*,
      (
        SELECT COUNT(companies.id) FROM companies
        WHERE country_id = countries.id
      ) AS company_count
    SQL
  })
end
