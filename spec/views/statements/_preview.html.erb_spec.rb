require 'rails_helper'

RSpec.describe 'statements/_preview.html.erb', type: :view do
  let(:statement) do
    stub_model(Statement,
               date_seen: Date.parse('1 Jan 2019'),
               url: 'http://example.com')
  end

  context 'when the statement also covers other companies' do
    let(:company) { stub_model(Company, name: 'company-name') }

    before do
      allow(statement).to receive(:additional_companies_covered).and_return([company])
      render partial: 'preview', locals: { statement: statement }
    end

    it 'links to the other companies' do
      expect(rendered).to have_link('company-name', href: company_statement_path(company, statement))
    end
  end
end
