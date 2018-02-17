Given(/^the following legislations exist:$/) do |table|
  table.hashes.each do |hash|
    Legislation.create!(
      name: hash['Name'],
      icon: hash['Name'].downcase.underscore,
      include_in_compliance_stats: hash['Include in compliance stats?'] == 'Yes'
    )
  end
end
