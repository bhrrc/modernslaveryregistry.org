Given(/^a statement was submitted for "([^"]*)" that responds with (PDF|HTML)$/) do |company_name, mime_type|
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
        content_type: 'image/jpeg',
        content_data: "image/jpeg snapshot for statement by '#{company_name}'"
      )
    )
  end
  submit_statement(statement_url: statement_url, company_name: company_name)
  expect(StatementUrl).to have_received(:fetch).with(statement_url)
end

When(/^(Joe|Patricia) views the latest snapshot of the statement for "([^"]*)"$/) do |actor, company_name|
  actor.attempts_to_view_the_latest_snapshot(company_name: company_name)
end

Then(/^(Joe|Patricia) should see a (PDF|PNG) snapshot of the statement for "([^"]*)"$/) do |actor, format, company_name|
  expect(actor.visible_snapshot).to eq("#{format.content_type} snapshot for statement by '#{company_name}'")
end

module ViewsSnapshots
  def attempts_to_view_the_latest_snapshot(company_name:)
    company = Company.find_by(name: company_name)
    visit(company_statement_path(company, company.latest_statement))
    within '[data-content="latest_shapshot"]' do
      click_on 'Download'
    end
  end

  def visible_snapshot
    text
  end
end

class Administrator
  include ViewsSnapshots
end
