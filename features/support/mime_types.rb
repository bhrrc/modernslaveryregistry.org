mime_types = {
  'PDF' => 'application/pdf',
  'HTML' => 'text/html',
  'JPEG' => 'image/jpeg'
}

class MimeType < Value.new(:format, :content_type)
  def extension
    format.downcase
  end
end

ParameterType(
  name: 'mime_type',
  regexp: /(#{mime_types.keys.join('|')})/,
  transformer: ->(str) { MimeType.with(format: str, content_type: mime_types[str]) }
)
