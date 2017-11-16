class Snapshot < ApplicationRecord
  belongs_to :statement, optional: true

  def previewable?
    image_of_html? || non_html_document?
  end

  private

  def html?
    content_type =~ /html/
  end

  def image_of_html?
    html? && image_content_type.present?
  end

  def non_html_document?
    !html?
  end
end
