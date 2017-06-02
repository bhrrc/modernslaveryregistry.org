class ScreenGrab
  def self.fetch(url)
    kit = IMGKit.new(url)
    FetchResult.with(
      url: url,
      broken_url: false,
      content_data: kit.to_jpg,
      content_type: 'image/jpeg'
    )
  rescue IMGKit::CommandFailedError
    FetchResult.with(
      url: url,
      broken_url: true,
      content_data: nil,
      content_type: nil
    )
  end
end
