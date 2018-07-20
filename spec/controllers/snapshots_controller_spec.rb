require 'rails_helper'

RSpec.describe SnapshotsController, type: :controller do
  describe 'GET #show' do
    it 'redirects to the snapshot' do
      include Rails.application.routes.url_helpers

      company = Company.create!(name: 'company-name')
      statement = company.statements.create!(url: 'http://example.com')
      snapshot = statement.create_snapshot!
      snapshot.original.attach(
        io: StringIO.new('original-in-active-storage'),
        filename: 'original.html'
      )

      get :show, params: { company_id: company.id, statement_id: statement.id }

      expected_url = rails_blob_path(snapshot.screenshot_or_original, only_path: true)
      expect(response).to redirect_to(/#{expected_url}/)
    end
  end
end
