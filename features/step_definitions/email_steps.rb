Then(/^"([^"]*)" should receive a thank you for submitting email$/) do |email_address|
  open_email(email_address)
  expect(current_email.subject).to eq 'Your submission to the Modern Slavery Registry'
end

Then(/^Patricia should not receive a thank you for submitting email$/) do
  expect(all_emails).to eq([])
end
