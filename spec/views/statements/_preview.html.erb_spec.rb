require 'rails_helper'

RSpec.describe 'statements/_preview.html.erb', type: :view do
  let(:company) { stub_model(Company, name: 'company-name') }
  let(:statement) do
    stub_model(Statement,
               company: company,
               date_seen: Date.parse('1 Jan 2019'),
               url: 'http://example.com')
  end

  before do
    allow(statement).to receive(:published_by?)
  end

  context 'when the statement was published by another company' do
    let(:other_company) { stub_model(Company, name: 'other-company') }

    before do
      allow(statement).to receive(:published_by?).with(company).and_return(false)
      render partial: 'preview', locals: { company: other_company, statement: statement }
    end

    it 'links to the publishing company' do
      expect(rendered).to have_link('company-name', href: company_statement_path(company, statement))
    end
  end

  context 'when the statement also covers other companies' do
    let(:other_company) { stub_model(Company, name: 'company-name') }

    before do
      allow(statement).to receive(:additional_companies_covered_excluding).with(company).and_return([other_company])
      render partial: 'preview', locals: { company: company, statement: statement }
    end

    it 'links to the other companies' do
      expect(rendered).to have_link('company-name', href: company_statement_path(other_company, statement))
    end
  end
end
