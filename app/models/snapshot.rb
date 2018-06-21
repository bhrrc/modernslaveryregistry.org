class Snapshot < ApplicationRecord
  belongs_to :statement, optional: true

  def screenshot_or_original
    return screenshot_file if screenshot_file.attached?
    original_file
  end

  def previewable?
    image_of_html? || original_is_not_html?
  end

  private

  def original_is_html?
    content_type =~ /html/
  end

  def image_of_html?
    original_is_html? && screenshot_file.attached?
  end

  def original_is_not_html?
    !original_is_html?
  end

  def original_file
    Attachment.new(content_data, content_type)
  end

  def screenshot_file
    Attachment.new(image_content_data, image_content_type)
  end

  class Attachment < Value.new(:download, :content_type)
    def attached?
      download.present?
    end
  end
end
