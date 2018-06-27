class Snapshot < ApplicationRecord
  belongs_to :statement, optional: true

  has_one_attached :original
  has_one_attached :screenshot

  def screenshot_or_original
    return screenshot if screenshot.attached?
    return original if original.attached?
    original_file
  end

  def previewable?
    (original_is_html? && screenshot.attached?) || original_is_not_html?
  end

  def original_is_pdf?
    original.content_type =~ /pdf/
  end

  private

  def original_is_html?
    original.content_type =~ /html/
  end

  def original_is_not_html?
    !original_is_html?
  end

  def original_file
    Attachment.new(content_data, content_type)
  end

  class Attachment < Value.new(:download, :content_type)
    def attached?
      download.present?
    end
  end
end
