Given(/^company "([^"]*)" has been registered$/) do |company_name|
  Company.create!(name: company_name)
end
