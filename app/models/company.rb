class Company < ApplicationRecord
  has_many :statements, dependent: :destroy
  belongs_to :country
  belongs_to :sector, optional: true

  validates :name, presence: true

  # http://www.toasterlovin.com/greatest-per-group-rails-scoped-has-one/
  has_one :newest_statement, -> {
    select("DISTINCT ON (company_id) *")
    .order(:company_id, date_seen: :desc)
  }, class_name: 'Statement'

  accepts_nested_attributes_for :statements, reject_if: :all_blank, allow_destroy: true

  def self.search(query)
    result = self

    if (query[:company_name])
      result = result.where("LOWER(name) LIKE LOWER(?)", "%#{query[:company_name]}%")
    end
    if (query[:sectors])
      result = result.where(sector_id: query[:sectors])
    end
    if (query[:countries])
      result = result.where(country_id: query[:countries])
    end

    if (result == self)
      result = all
    end

    result.includes(:newest_statement, :country, :sector)
  end
end
