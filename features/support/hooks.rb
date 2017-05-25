Before do
  Country.find_or_create_by!(code: 'GB', name: 'United Kingdom')
  Country.find_or_create_by!(code: 'US', name: 'United States')
  Country.find_or_create_by!(code: 'FR', name: 'France')
  Sector.find_or_create_by!(name: 'Software')
  Sector.find_or_create_by!(name: 'Agriculture')
  Sector.find_or_create_by!(name: 'Retail')
end

# rubocop: disable Lint/Debugger, Style/RescueModifier
After do |scenario|
  if scenario.failed?
    save_and_open_page
    save_and_open_screenshot rescue nil
  end
end
