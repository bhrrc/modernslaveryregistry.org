class Industry < ApplicationRecord
  has_many :companies, dependent: :restrict_with_exception
  has_many :countries, -> { distinct }, through: :companies

  scope(:with_companies, lambda {
    joins(:companies).group('industries.id')
  })

  scope(:with_company_counts, lambda {
    select <<~SQL
      industries.*,
      (
        SELECT COUNT(companies.id) FROM companies
        WHERE industry_id = industries.id
      ) AS company_count
    SQL
  })

  after_commit :reindex_companies

  def reindex_companies
    companies.each(&:reindex)
  end

  def deep_name
    "#{sector_name} > #{industry_group_name} > #{name}"
  end
end
