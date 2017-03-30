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
    if (query)
      where("LOWER(name) LIKE LOWER(?)", "%#{query}%")
    else
      []
      #Company.includes(:newest_statement, :country, :sector).last(10)
    end
  end
end
