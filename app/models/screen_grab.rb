class ScreenGrab
  def self.fetch(url)
    kit = IMGKit.new(url, quality: 1)
    FetchResult.with(url: url, broken_url: false, content_data: kit.to_png, content_type: 'image/png')
  rescue IMGKit::CommandFailedError => e
    Rails.logger.error e
    FetchResult.with(url: url, broken_url: true, content_data: nil, content_type: nil)
  end
end
