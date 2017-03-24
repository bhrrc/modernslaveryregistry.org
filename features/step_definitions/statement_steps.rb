class RegisterStatement < Fellini::Task
  def perform_as(actor)
    actor.attempts_to(SubmitRegisterStatementForm.new(
      @company_name,
      @url,
      @signed_by_director
    ))
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

class SubmitRegisterStatementForm < Fellini::Interaction
  include Capybara::DSL

  def perform_as(actor)
    company = Company.find_by_name(@company_name)
    #visit company_url(company)
    visit "/companies/#{company.id}"
    fill_in 'URL', with: @company_name
    fill_in 'Signed by director', with: @signed_by_director

    click_button 'Register'
  end

  def initialize(company_name, url, signed_by_director)
    @company_name, @url, @signed_by_director = company_name, url, signed_by_director
  end
end

When(/^([A-Z]\w+) registers the following statement:$/) do |actor, table|
  props = table.rows_hash
  # company = Company.find_by_name()
  # company.create_statement(props)
  actor.attempts_to(
    RegisterStatement
      .for_company(props['company_name'])
      .with_statement_url(props['url'])
      .signed_by_director(props['signed_by_director'] == 'yes')
  )
end
