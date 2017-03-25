class RegisterStatement < Fellini::Task
  def perform_as(actor)
    company = Company.find_by_name(@company_name)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    browser.visit("/companies/#{company.id}")
    browser.fill_in('Statement URL', with: @url)
    browser.check('Signed by director') if @signed_by_director
    browser.click_button 'Register'
  end

  def self.for_company(company_name)
    instrumented(self, company_name)
  end

  def initialize(company_name)
    @company_name = company_name
  end

  def with_statement_url(url)
    @url = url
    self
  end

  def signed_by_director(bool)
    @signed_by_director = bool
    self
  end
end

class StatementUrls < Fellini::Question
  class << self
    delegate :url_helpers, to: 'Rails.application.routes'
  end

  def answered_by(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    browser.visit(@page_url)
    browser.all('[data-content="statement-url"]').map {|url_element| url_element.text}
  end

  def initialize(page_url)
    @page_url = page_url
  end

  def self.of(company_name)
    new(url_helpers.company_path(Company.find_by_name(company_name)))
  end

  def self.total()
    new('/')
  end
end

Given(/^the following statement have been registered:$/) do |table|
  table.hashes.each do |props|
    company = Company.find_or_create_by(name: props['company_name'])
    company.statements.create!({url: props['statement_url']})
  end
end

When(/^([A-Z]\w+) registers the following statement:$/) do |actor, table|
  props = table.rows_hash
  actor.attempts_to(
    RegisterStatement
      .for_company(props['company_name'])
      .with_statement_url(props['url'])
      .signed_by_director(props['signed_by_director'] == 'yes')
  )
end

Then(/^([A-Z]\w+) should see (\d+) statements? on the "([^"]*)" company page$/) do |actor, statement_count, company_name|
  expect(actor.to_see(StatementUrls.of(company_name)).length()).to eq(statement_count.to_i)
end

Then(/^([A-Z]\w+) should see (\d+) statements total$/) do |actor, statement_count|
  expect(actor.to_see(StatementUrls.total).length()).to eq(statement_count.to_i)
end
