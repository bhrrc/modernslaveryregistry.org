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
  actor.attempts_to(
    CreatePage.with(
      slug: 'new-page',
      title: 'New Page',
      short_title: 'New Page',
      body_html: '<b>This is the body</b>'
    )
  )
end

When(/^(Joe|Patricia) edits an existing page$/) do |actor|
  Page.create!(slug: 'existing-page', title: 'Existing Title', short_title: 'Existing', body_html: 'Existing Body')
  actor.attempts_to(
    EditPage.with_title('Existing Title')
      .new_title('New Title')
      .new_slug('new-slug')
      .new_body_html('New Body')
  )
end

When(/^(Joe|Patricia) deletes an existing page$/) do |actor|
  Page.create!(slug: 'page-to-delete', title: 'Title To Delete', short_title: 'To Delete', body_html: 'Body To Delete')
  actor.attempts_to(
    DeletePage.with_title('Title To Delete')
  )
end

When(/^(Joe|Patricia) moves the page "([^"]+)" (up|down)$/) do |actor, page_title, direction|
  actor.attempts_to(
    MovePage.with_title(page_title)
      .in_direction(direction)
  )
end

Then(/^(Joe|Patricia) should see the new page on the website$/) do |actor|
  expect(actor.to_see(ThePage.entitled('New Page')).page_html).to eq('<b>This is the body</b>')
end

Then(/^(Joe|Patricia) should see the updated page on the website$/) do |actor|
  expect(actor.to_see(ThePage.entitled('New Title')).page_html).to eq('New Body')
end

Then(/^(Joe|Patricia) should see the following menu on the website:$/) do |actor, table|
  expect(actor.to_see(TheMenu.in_the_home_page_header).titles).to eq(table.hashes.map { |props| props['title'] })
end

Then(/^(Joe|Patricia) should not see the deleted page on the website$/) do |actor|
  expect(actor.to_see(TheMenu.in_the_home_page_header).titles).to eq([])
end

class CreatePage < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)

    browser.visit(admin_pages_path)
    browser.click_on 'New Page'
    browser.fill_in('Title', with: @title)
    browser.fill_in('Short title', with: @short_title)
    browser.fill_in('Slug', with: @slug)
    browser.fill_in('Body html', with: @body_html)
    browser.click_on 'Create Page'
  end

  def self.with(slug:, title:, short_title:, body_html:)
    instrumented(self, slug: slug, title: title, short_title: short_title, body_html: body_html)
  end

  def initialize(slug:, title:, short_title:, body_html:)
    @slug = slug
    @title = title
    @short_title = short_title
    @body_html = body_html
  end
end

class EditPage < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)

    browser.visit(admin_pages_path)
    browser.click_on @title
    browser.fill_in('Title', with: @new_title) if @new_title.present?
    browser.fill_in('Short title', with: @new_short_title) if @new_short_title.present?
    browser.fill_in('Slug', with: @new_slug) if @new_slug.present?
    browser.fill_in('Body html', with: @new_body_html) if @new_body_html.present?
    browser.click_on 'Update Page'
  end

  def self.with_title(title)
    instrumented(self, title)
  end

  def initialize(title)
    @title = title
  end

  def new_title(title)
    @new_title = title
    self
  end

  def new_short_title(short_title)
    @new_short_title = short_title
    self
  end

  def new_slug(slug)
    @new_slug = slug
    self
  end

  def new_body_html(body_html)
    @new_body_html = body_html
    self
  end
end

class DeletePage < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)

    browser.visit(admin_pages_path)
    browser.click_on "Delete '#{@title}'"
  end

  def self.with_title(title)
    instrumented(self, title)
  end

  def initialize(title)
    @title = title
  end
end

class MovePage < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    page = Page.find_by!(title: @title)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)

    browser.visit(admin_pages_path)
    browser.click_on "Move '#{page.title}' #{@direction}"
  end

  def self.with_title(title)
    instrumented(self, title)
  end

  def initialize(title)
    @title = title
  end

  def in_direction(direction)
    @direction = direction
    self
  end
end

class ThePage < Fellini::Question
  include Rails.application.routes.url_helpers

  def initialize(title)
    @title = title
  end

  def answered_by(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    browser.visit(page_path(Page.find_by!(title: @title)))
    RenderedPage.with(
      page_html: browser.find('[data-content="page_html"]').native.inner_html
    )
  end

  def self.entitled(title)
    new(title)
  end

  class RenderedPage < Value.new(:page_html)
  end
end

class TheMenu < Fellini::Question
  include Rails.application.routes.url_helpers

  def answered_by(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    browser.visit(root_path)
    NavMenu.with(
      titles: browser.all('header .nav-menu .nav-item').map(&:text)
    )
  end

  def self.in_the_home_page_header
    new
  end

  class NavMenu < Value.new(:titles)
  end
end
