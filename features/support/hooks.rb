Before do
  Country.create!(name: 'United Kingdom', code: 'GB')
  Sector.create!(name: 'Software')
end

After do |scenario|
  if scenario.failed?
    save_and_open_page
    save_and_open_screenshot rescue nil
  end
end
