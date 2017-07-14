Given(/^the following pages exist:$/) do |table|
  table.hashes.each do |props|
    Page.create!(
      title: props['title'],
      short_title: props['title'],
      slug: props['title'].downcase.delete(' '),
      body_html: "Body of #{props['title']}",
      published: props['published'] == 'yes'
    )
  end
end

When(/^(Joe|Patricia) creates a new page$/) do |actor|
  actor.attempts_to_create_page(
    slug: 'new-page',
    title: 'New Page',
    short_title: 'New Page',
    body_html: '<b>This is the body</b>'
  )
end

When(/^(Joe|Patricia|Vicky) visits the page$/) do |actor| # rubocop:disable Style/SymbolProc
  actor.attempts_to_visit_latest_page
end

When(/^(Joe|Patricia) edits an existing page$/) do |actor|
  Page.create!(slug: 'existing-page', title: 'Existing Title', short_title: 'Existing', body_html: 'Existing Body')
  actor.attempts_to_edit_page(
    title: 'Existing Title',
    updates: {
      title: 'New Title',
      slug: 'new-slug',
      body_html: 'New Body'
    }
  )
end

When(/^(Joe) publishes a page$/) do |actor|
  Page.create!(slug: 'existing-page', title: 'Title', short_title: 'Title', body_html: 'Body')
  actor.attempts_to_edit_page(
    title: 'Title',
    updates: {
      published: true
    }
  )
end

When(/^(Joe) unpublishes a page$/) do |actor|
  Page.create!(slug: 'existing-page', title: 'Title', short_title: 'Title', body_html: 'Body', published: true)
  actor.attempts_to_edit_page(
    title: 'Title',
    updates: {
      published: false
    }
  )
end

When(/^(Joe|Patricia) deletes an existing page$/) do |actor|
  Page.create!(slug: 'page-to-delete', title: 'Title To Delete', short_title: 'To Delete', body_html: 'Body To Delete')
  actor.attempts_to_delete_page(title: 'Title To Delete')
end

When(/^(Joe|Patricia) moves the page "([^"]+)" (up|down)$/) do |actor, title, direction|
  actor.attempts_to_move_page(title: title, direction: direction)
end

When(/^(Vicky) visits the page "([^"]*)"$/) do |actor, title|
  actor.attempts_to_visit_page(title: title)
end

Then(/^(Joe|Patricia) should see the new page on the website$/) do |actor|
  expect(actor.visible_page.page_html).to eq('<b>This is the body</b>')
end

Then(/^(Vicky) should see the page on the website$/) do |actor|
  expect(actor.visible_page.page_html).to eq(Page.last.body_html)
end

Then(/^(Vicky) should not see the page on the website$/) do |actor|
  expect(actor.visible_page).to be_nil
end

Then(/^(Joe|Patricia) should see the updated page on the website$/) do |actor|
  expect(actor.visible_page.page_html).to eq('New Body')
end

Then(/^(Joe|Patricia) should see the following menu on the website:$/) do |actor, table|
  expect(actor.visible_main_navigation_menu.titles).to eq(table.hashes.map { |props| props['title'] })
end

Then(/^(Joe|Patricia) should not see the deleted page on the website$/) do |actor|
  expect(actor.visible_main_navigation_menu.titles).to eq([])
end

Then(/^(Vicky) should see the following pages on the website:$/) do |actor, table|
  expect(actor.visible_main_navigation_menu.titles).to eq(table.hashes.map { |props| props['title'] })
end

module ManagesPages
  def attempts_to_create_page(slug:, title:, short_title:, body_html:)
    visit admin_pages_path
    click_on 'New Page'
    fill_in('Title', with: title)
    fill_in('Short title', with: short_title)
    fill_in('Slug', with: slug)
    find('input[name="page[body_html]"]', visible: false).set(body_html)
    click_on 'Create Page'
  end

  def attempts_to_edit_page(title:, updates:)
    visit admin_pages_path
    click_on title
    updates.each do |attribute, value|
      set_page_attribute(attribute, value)
    end
    click_on 'Update Page'
  end

  def attempts_to_delete_page(title:)
    visit admin_pages_path
    click_on "Delete '#{title}'"
  end

  def attempts_to_move_page(title:, direction:)
    visit admin_pages_path
    click_on "Move '#{title}' #{direction}"
  end

  private

  def set_page_attribute(attribute, value)
    if %i[title short_title slug].include?(attribute)
      fill_in attribute.to_s.humanize, with: value
    elsif attribute == :body_html
      find('input[name="page[body_html]"]', visible: false).set value
    elsif attribute == :published
      value ? check('Published?') : uncheck('Published?')
    else
      raise "#{attribute} is not a page attribute"
    end
  end
end

module SeesPages
  def attempts_to_visit_latest_page
    try_to_visit(Page.last)
  rescue ActionController::UrlGenerationError
    nil
  end

  def attempts_to_visit_page(title:)
    try_to_visit(Page.find_by!(title: title))
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def visible_page
    RenderedPage.with(
      page_html: find('[data-content="page_html"]').native.inner_html
    )
  rescue Capybara::ElementNotFound
    nil
  end

  class RenderedPage < Value.new(:page_html)
  end

  def visible_main_navigation_menu
    visit root_path
    NavMenu.with(titles: all('header .nav-menu .nav-item').map(&:text))
  end

  class NavMenu < Value.new(:titles)
  end

  private

  def try_to_visit(page)
    visit page_path(page)
  rescue ActiveRecord::RecordNotFound
    nil
  end
end

class Administrator
  include ManagesPages
end

class Visitor
  include SeesPages
end
