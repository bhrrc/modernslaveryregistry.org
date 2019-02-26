require 'rails_helper'

RSpec.describe 'admin/statements/_details.html.erb', type: :view do
  let(:company) { stub_model(Company, name: 'company-name') }
  let(:statement) { stub_model(Statement, company: company, url: 'http://example.com') }

  it 'links to the company that produced the statement' do
    render partial: 'details', locals: { statement: statement }

    url = admin_company_path(company)
    expect(rendered).to have_css("div[data-content='company_name'] a[href='#{url}']", text: 'company-name')
  end
end
