Given(/^the following Legislations exist:$/) do |table|
  table.hashes.each do |hash|
    Legislation.create!(name: hash['Name'], icon: hash['Name'].downcase.underscore)
  end
end
