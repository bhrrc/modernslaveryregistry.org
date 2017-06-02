mime_types = {
  'PDF' => 'application/pdf',
  'HTML' => 'text/html',
  'PNG' => 'image/png'
}

class MimeType < Value.new(:format, :content_type)
  def extension
    format.downcase
  end
end

mime_types.each do |format, content_type|
  Transform(/^(#{format})$/) do |f|
    MimeType.with(format: f, content_type: content_type)
  end
end
