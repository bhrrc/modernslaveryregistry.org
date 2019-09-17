When('{actor} downloads the full CSV') do |actor| # rubocop:disable Style/SymbolProc
  actor.attempts_to_download_full_csv
end

Then('{actor} should see all the published statements') do |actor|
  expected_downloads = Statement.published.map(&:url)
  expect(actor.visible_downloaded_statement_urls.uniq).to match_array(expected_downloads)
end

Then('{actor} should see all the statements including drafts') do |actor|
  expected_downloads = Statement.all.map do |statement|
    DownloadedStatement.with(
      company_name: statement.company.name,
      company_url: statement.url,
      industry_name: statement.company.industry.name,
      country_name: statement.company.country.name
    )
  end
  expect(actor.visible_downloaded_statements).to match_array(expected_downloads)
end

module DownloadsStatements
  def attempts_to_download_full_csv
    visit explore_path
    click_link 'Download CSV'
  end

  def visible_downloaded_statement_urls
    CSV.parse(html, headers: true).map do |row|
      row['URL']
    end
  end

  def visible_downloaded_statements
    CSV.parse(html, headers: true).map(&:to_h).map do |row|
      DownloadedStatement.with(
        company_name: row['Company'],
        company_url: row['URL'],
        industry_name: row['Industry'],
        country_name: row['HQ']
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
  :industry_name,
  :country_name
)
end
