require 'cucumber/rspec/doubles'

Before do
  Rails.application.config.active_job.queue_adapter = :inline
  Country.find_or_create_by!(code: 'GB', name: 'United Kingdom')
  Country.find_or_create_by!(code: 'US', name: 'United States')
  Country.find_or_create_by!(code: 'FR', name: 'France')
  Industry.find_or_create_by!(name: 'Software')
  Industry.find_or_create_by!(name: 'Agriculture')
  Industry.find_or_create_by!(name: 'Retail')

  allow(StatementUrl).to receive(:fetch) do |url|
    FetchResult.with(
      url: url,
      broken_url: false,
      content_type: 'text/html',
      content_data: '<html />'
    )
  end

  allow(ScreenGrab).to receive(:fetch) do |url|
    FetchResult.with(
      url: url,
      broken_url: false,
      content_type: 'image/jpeg',
      content_data: 'image data!'
    )
  end
end

# rubocop: disable Lint/Debugger, Style/RescueModifier
After do |scenario|
  if scenario.failed? && ENV['DEBUG']
    save_and_open_page
    save_and_open_screenshot rescue nil
  end
end
# rubocop: enable Lint/Debugger, Style/RescueModifier
