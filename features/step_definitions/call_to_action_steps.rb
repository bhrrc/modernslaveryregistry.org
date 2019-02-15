When('Joe creates a new call to action') do
  visit admin_call_to_actions_path
  click_on 'New Call to Action'
  fill_in('Title', with: 'New call to action')
  fill_in('Button text', with: 'button-text')
  fill_in('Url', with: 'http://example.com')
  fill_in('Body', with: 'body-text')
  click_on 'Create Call to action'
end

When('Joe visits the homepage') do
  visit root_path
end

Then('Joe should see the new call to action on the homepage') do
  expect(page).to have_content('New call to action')
end

When('Joe edits an existing call to action') do
  CallToAction.create!(title: 'Existing call to action',
                       button_text: 'button-text',
                       url: 'http://example.com',
                       body: 'body')

  visit admin_call_to_actions_path
  click_on 'Existing call to action'
  fill_in('Title', with: 'Updated call to action')
  click_on 'Update Call to action'
end

Then('Joe should see the updated call to action on the homepage') do
  expect(page).to have_content('Updated call to action')
end

When('Joe deletes an existing call to action') do
  CallToAction.create!(title: 'Existing call to action',
                       button_text: 'button-text',
                       url: 'http://example.com',
                       body: 'body')
  visit admin_call_to_actions_path
  click_on "Delete 'Existing call to action'"
end

Then('Joe should not see the deleted call to action on the homepage') do
  expect(page).not_to have_content('Existing call to action')
end
