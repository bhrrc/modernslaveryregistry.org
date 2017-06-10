class Company < ApplicationRecord
  has_many :statements, dependent: :destroy
  belongs_to :country, optional: true
  belongs_to :sector, optional: true

  validates :name, presence: true

  accepts_nested_attributes_for :statements, reject_if: :all_blank, allow_destroy: true

  def latest_statement
    statements.latest.first
  end

  def country_name
    try(:country).try(:name) || 'Country unknown'
  end

  def sector_name
    try(:sector).try(:name) || 'Sector unknown'
  end
end
