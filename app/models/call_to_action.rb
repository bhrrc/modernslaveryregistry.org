class CallToAction < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true
  validates :url, presence: true
  validates :button_text, presence: true
end
