class CallToAction < ApplicationRecord
  acts_as_list

  validates :title, presence: true
  validates :body, presence: true
  validates :url, presence: true
  validates :button_text, presence: true

  scope(:as_list, -> { order(:position) })
end
