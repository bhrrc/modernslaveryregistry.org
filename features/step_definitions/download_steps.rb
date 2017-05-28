When(/^(Joe|Patricia) downloads all statements$/) do |actor|
  actor.attempts_to(
    DownloadStatements.all
  )
end

Then(/^(Joe|Patricia) should see all the published statements$/) do |actor|
  expected_downloads = Statement.published.map do |statement|
    DownloadedStatement.with(
      company_name: statement.company.name,
      company_url: statement.url,
      sector_name: statement.company.sector.name,
      country_name: statement.company.country.name,
      date_seen: statement.date_seen.iso8601
    )
  end
  expect(actor.to_see(DownloadedStatements.all)).to match_array(expected_downloads)
end

Then(/^(Joe|Patricia) should see all the statements including drafts$/) do |actor|
  expected_downloads = Statement.all.map do |statement|
    DownloadedStatement.with(
      company_name: statement.company.name,
      company_url: statement.url,
      sector_name: statement.company.sector.name,
      country_name: statement.company.country.name,
      date_seen: statement.date_seen.iso8601
    )
  end
  expect(actor.to_see(DownloadedStatements.all)).to match_array(expected_downloads)
end

class DownloadStatements < Fellini::Task
  include Rails.application.routes.url_helpers

  def perform_as(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    browser.visit(root_path)
    browser.click_link('Download statements')
  end

  def self.all
    instrumented(self)
  end
end

class DownloadedStatements < Fellini::Question
  include Rails.application.routes.url_helpers

  def answered_by(actor)
    browser = Fellini::Abilities::BrowseTheWeb.as(actor)
    CSV.parse(browser.html, headers: true).map(&:to_h).map do |row|
      DownloadedStatement.with(
        company_name: row['Company'],
        company_url: row['URL'],
        sector_name: row['Sector'],
        country_name: row['HQ'],
        date_seen: row['Date Added']
      )
    end
  end

  def self.all
    new
  end
end

class DownloadedStatement < Value.new(
  :company_name,
  :company_url,
  :sector_name,
  :country_name,
  :date_seen
)
end
