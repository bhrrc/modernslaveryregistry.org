class Company < ApplicationRecord
  has_many :statements, dependent: :destroy
  belongs_to :country
  belongs_to :sector, optional: true

  validates :name, presence: true

  accepts_nested_attributes_for :statements, reject_if: :all_blank, allow_destroy: true

  def newest_statement
    statements.newest.first
  end
end
