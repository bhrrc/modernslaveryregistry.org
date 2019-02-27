require 'rails_helper'

RSpec.describe 'admin/statements/_details.html.erb', type: :view do
  let(:company) { stub_model(Company, name: 'company-name') }
  let(:statement) { stub_model(Statement, company: company, url: 'http://example.com') }

  it 'links to the company that produced the statement' do
    render partial: 'details', locals: { company: company, statement: statement }

    url = admin_company_path(company)
    expect(rendered).to have_css("div[data-content='company_name'] a[href='#{url}']", text: 'company-name')
  end

  it 'links to additional companies covered by this statement' do
    another_company = stub_model(Company, name: 'another-company')
    allow(statement).to receive(:additional_companies_covered_excluding).with(company).and_return([another_company])

    render partial: 'details', locals: { company: company, statement: statement }

    url = admin_company_path(another_company)
    expect(rendered).to have_css("div[data-content='additional_companies'] a[href='#{url}']", text: 'another-company')
  end
end
