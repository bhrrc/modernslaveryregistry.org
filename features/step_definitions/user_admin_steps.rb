Given(/^(Vicky) has a user account$/) do |actor|
  find_or_create_user(actor)
end

When(/^(Patricia) searches users$/) do |actor| # rubocop:disable Style/SymbolProc
  actor.attempts_to_search_users
end

When(/^(Patricia) makes Vicky an administrator$/) do |actor|
  actor.attempts_to_make_user_administrator('Vicky')
end

When(/^(Patricia) makes Vicky a non-administrator$/) do |actor|
  actor.attempts_to_make_user_non_administrator('Vicky')
end

Then(/^(Patricia) should see Patricia and Vicky$/) do |actor|
  expect(actor.visible_user_account_first_names).to match_array(%w[Patricia Vicky])
end

Then(/^(Vicky) should have admin access$/) do |actor|
  expect(User.find_by!(first_name: actor.name)).to be_admin
end

Then(/^(Vicky) should not have admin access$/) do |actor|
  expect(User.find_by!(first_name: actor.name)).not_to be_admin
end

module ManagesUsers
  def attempts_to_search_users
    visit admin_users_path
    click_on 'Search'
  end

  def attempts_to_make_user_administrator(first_name)
    visit admin_users_path
    click_on first_name
    check 'Admin?'
    click_on 'Update User'
  end

  def attempts_to_make_user_non_administrator(first_name)
    visit admin_users_path
    click_on first_name
    uncheck 'Admin?'
    click_on 'Update User'
  end

  def visible_user_account_first_names
    dom_structs(:user, :first_name).map(&:first_name)
  end
end

class Visitor
  include ManagesUsers
end
