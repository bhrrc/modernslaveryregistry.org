require 'rails_helper'

RSpec.describe Admin::CompaniesController, type: :controller do
  describe 'POST #create' do
    it 'allows additional companies to be associated with the statement' do
      admin = User.create!(first_name: 'Admin', admin: true, email: 'admin@example.com', password: 'password')
      admin.confirm
      sign_in admin

      existing_company = Company.create!(name: 'existing-company')

      post :create, params: {
        company: {
          name: 'new-company',
          statements_attributes: [
            url: 'http://example.com',
            additional_companies_covered_ids: [existing_company]
          ]
        }
      }

      statement = Statement.first
      expect(statement.additional_companies_covered).to include(existing_company)
    end
  end
end
