When('{actor} downloads all statements') do |actor| # rubocop:disable Style/SymbolProc
  actor.attempts_to_download_all_statements
end

Then('{actor} should see all the published statements') do |actor|
  expected_downloads = Statement.published.map do |statement|
    DownloadedStatement.with(
      company_name: statement.company.name,
      company_url: statement.url,
      sector_name: statement.company.sector.name,
      country_name: statement.company.country.name,
      date_seen: statement.date_seen.iso8601
    )
  end
  expect(actor.visible_downloaded_statements).to match_array(expected_downloads)
end

Then('{actor} should see all the statements including drafts') do |actor|
  expected_downloads = Statement.all.map do |statement|
    DownloadedStatement.with(
      company_name: statement.company.name,
      company_url: statement.url,
      sector_name: statement.company.sector.name,
      country_name: statement.company.country.name,
      date_seen: statement.date_seen.iso8601
    )
  end
  expect(actor.visible_downloaded_statements).to match_array(expected_downloads)
end

module DownloadsStatements
  def attempts_to_download_all_statements
    visit root_path
    click_link 'Download statements'
  end

  def visible_downloaded_statements
    CSV.parse(html, headers: true).map(&:to_h).map do |row|
      DownloadedStatement.with(
        company_name: row['Company'],
        company_url: row['URL'],
        sector_name: row['Sector'],
        country_name: row['HQ'],
        date_seen: row['Date Added']
      )
    end
  end
end

class Visitor
  include DownloadsStatements
end

class DownloadedStatement < Value.new(
  :company_name,
  :company_url,
  :sector_name,
  :country_name,
  :date_seen
)
end
