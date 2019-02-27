require 'rails_helper'

RSpec.describe Admin::StatementsController, type: :controller do
  let(:company1) { Company.create!(name: 'company-1') }
  let(:company2) { Company.create!(name: 'company-2') }

  before do
    admin = User.create!(first_name: 'Admin', admin: true, email: 'admin@example.com', password: 'password')
    admin.confirm
    sign_in admin
  end

  describe 'POST #create' do
    it 'allows additional companies to be associated with the statement' do
      post :create, params: {
        company_id: company1,
        statement: {
          url: 'http://example.com',
          additional_companies_covered_ids: [company2]
        }
      }

      statement = Statement.first
      expect(statement.additional_companies_covered).to include(company2)
    end
  end

  describe 'PUT #update' do
    it 'allows additional companies to be associated with the statement' do
      statement = company1.statements.create!(url: 'http://example.com')

      put :update, params: {
        id: statement,
        statement: {
          additional_companies_covered_ids: [company2]
        }
      }

      statement.reload
      expect(statement.additional_companies_covered).to include(company2)
    end
  end
end
