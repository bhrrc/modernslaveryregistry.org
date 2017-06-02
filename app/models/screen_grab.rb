class ScreenGrab
  def self.fetch(url)
    kit = IMGKit.new(url)
    FetchResult.with(
      url: url,
      broken_url: false,
      content_data: kit.to_png,
      content_type: 'image/png'
    )
  end
end
