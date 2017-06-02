Given(/^a statement was submitted for "([^"]*)" that responds with a (PDF|HTML)$/) do |company_name, mime_type|
  statement_url = "https://cucumber.io/statement.#{mime_type.extension}"
  content_data = "#{mime_type.content_type} snapshot for statement by '#{company_name}'"
  allow(StatementUrl).to receive(:fetch).with(statement_url).and_return(
    FetchResult.with(
      url: statement_url,
      broken_url: false,
      content_type: mime_type.content_type,
      content_data: content_data
    )
  )
  if mime_type.format == 'HTML'
    allow(ScreenGrab).to receive(:fetch).with(statement_url).and_return(
      FetchResult.with(
        url: statement_url,
        broken_url: false,
        content_type: 'image/png',
        content_data: "image/png snapshot for statement by '#{company_name}'"
      )
    )
  end
  submit_statement(statement_url: statement_url, company_name: company_name)
  expect(StatementUrl).to have_received(:fetch).with(statement_url)
end

When(/^(Joe|Patricia) views the latest snapshot of the statement for "([^"]*)"$/) do |actor, company_name|
  actor.attempts_to(ViewLatestSnapshot.for_company(company_name))
end

Then(/^(Joe|Patricia) should see a (PDF|PNG) snapshot of the statement for "([^"]*)"$/) do |actor, format, company_name|
  expect(actor.to_see(TheVisibleSnapshot.snapshot)).to eq("#{format.content_type} snapshot for statement by '#{company_name}'")
end

class ViewLatestSnapshot < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)

    company = Company.find_by(name: @company_name)
    browser.visit(company_statement_path(company, company.newest_statement))
    browser.within '[data-content="latest_shapshot"]' do
      browser.click_on 'Download'
    end
  end

  def self.for_company(company_name)
    new(company_name)
  end

  def initialize(company_name)
    @company_name = company_name
  end
end

class TheVisibleSnapshot < Fellini::Question
  def answered_by(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    browser.text
  end

  def self.snapshot
    new
  end
end
