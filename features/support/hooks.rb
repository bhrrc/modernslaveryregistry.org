Before do
  Country.create!(name: 'United Kingdom', code: 'GB')
  Sector.create!(name: 'Software')
end

After do
  save_and_open_screenshot rescue nil
end
