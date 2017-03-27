class Company < ApplicationRecord
  has_many :statements, dependent: :destroy
  has_one :country
  has_one :sector

  # http://www.toasterlovin.com/greatest-per-group-rails-scoped-has-one/
  has_one :newest_statement, -> {
    select("DISTINCT ON (company_id) *")
    .order(:company_id, date_seen: :desc)
  }, class_name: 'Statement'

  accepts_nested_attributes_for :statements, reject_if: :all_blank, allow_destroy: true
end
