class UrlFormatValidator < ActiveModel::Validator
  def validate(record)
    URI(record.url) if record.url.present?
  rescue URI::InvalidURIError
    record.errors[:url] << 'is not a valid URL'
  end
end
