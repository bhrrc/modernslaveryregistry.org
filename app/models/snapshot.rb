class Snapshot < ApplicationRecord
  belongs_to :statement, optional: true

  has_one_attached :original
  has_one_attached :screenshot

  def screenshot_or_original
    return screenshot if screenshot.attached?
    original
  end

  def previewable?
    (original_is_html? && screenshot.attached?) || original_is_not_html?
  end

  def original_is_html?
    original.content_type =~ /html/
  end

  def should_have_screenshot?
    original_is_html?
  end

  private

  def original_is_not_html?
    !original_is_html?
  end
end
