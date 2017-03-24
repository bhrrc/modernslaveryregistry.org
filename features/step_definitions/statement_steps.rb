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

When(/^([A-Z]\w+) registers the following statement:$/) do |actor, table|
  props = table.rows_hash
  actor.attempts_to(
    RegisterStatement
      .for_company(props['company_name'])
      .with_statement_url(props['url'])
      .signed_by_director(props['signed_by_director'] == 'yes')
  )
end
