Given(/^the following pages exist:$/) do |table|
  table.hashes.each do |props|
    Page.create!(
      title: props['title'],
      short_title: props['title'],
      slug: props['title'].downcase.delete(' '),
      body_html: "Body of #{props['title']}"
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

When(/^(Joe|Patricia) deletes an existing page$/) do |actor|
  Page.create!(slug: 'page-to-delete', title: 'Title To Delete', short_title: 'To Delete', body_html: 'Body To Delete')
  actor.attempts_to_delete_page(title: 'Title To Delete')
end

When(/^(Joe|Patricia) moves the page "([^"]+)" (up|down)$/) do |actor, title, direction|
  actor.attempts_to_move_page(title: title, direction: direction)
end

Then(/^(Joe|Patricia) should see the new page on the website$/) do |actor|
  expect(actor.visible_page(title: 'New Page').page_html).to eq('<b>This is the body</b>')
end

Then(/^(Joe|Patricia) should see the updated page on the website$/) do |actor|
  expect(actor.visible_page(title: 'New Title').page_html).to eq('New Body')
end

Then(/^(Joe|Patricia) should see the following menu on the website:$/) do |actor, table|
  expect(actor.visible_main_navigation_menu.titles).to eq(table.hashes.map { |props| props['title'] })
end

Then(/^(Joe|Patricia) should not see the deleted page on the website$/) do |actor|
  expect(actor.visible_main_navigation_menu.titles).to eq([])
end

module AttemptsToCreatePage
  def attempts_to_create_page(slug:, title:, short_title:, body_html:)
    visit admin_pages_path
    click_on 'New Page'
    fill_in('Title', with: title)
    fill_in('Short title', with: short_title)
    fill_in('Slug', with: slug)
    find('input[name="page[body_html]"]', visible: false).set(body_html)
    click_on 'Create Page'
  end
end

module AttemptsToEditPage
  def attempts_to_edit_page(title:, updates:)
    visit admin_pages_path
    click_on title
    updates.each do |attribute, value|
      set_page_attribute(attribute, value)
    end
    click_on 'Update Page'
  end

  private

  def set_page_attribute(attribute, value)
    if %i[title short_title slug].include?(attribute)
      fill_in attribute.to_s.humanize, with: value
    elsif attribute == :body_html
      find('input[name="page[body_html]"]', visible: false).set value
    else
      raise "#{attribute} is not a page attribute"
    end
  end
end

module AttemptsToDeletePage
  def attempts_to_delete_page(title:)
    visit admin_pages_path
    click_on "Delete '#{title}'"
  end
end

module AttemptsToMovePage
  def attempts_to_move_page(title:, direction:)
    visit admin_pages_path
    click_on "Move '#{title}' #{direction}"
  end
end

module SeesThePage
  def visible_page(title:)
    visit page_path(Page.find_by!(title: title))
    RenderedPage.with(
      page_html: find('[data-content="page_html"]').native.inner_html
    )
  end

  class RenderedPage < Value.new(:page_html)
  end
end

module SeesTheMainNavigationMenu
  def visible_main_navigation_menu
    visit root_path
    NavMenu.with(titles: all('header .nav-menu .nav-item').map(&:text))
  end

  class NavMenu < Value.new(:titles)
  end
end

class Administrator
  include AttemptsToCreatePage
  include AttemptsToEditPage
  include AttemptsToDeletePage
  include AttemptsToMovePage
  include SeesThePage
  include SeesTheMainNavigationMenu
end
