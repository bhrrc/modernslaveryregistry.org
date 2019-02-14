require 'rails_helper'

RSpec.describe 'Health Check', type: :request do
  describe 'GET /health_check' do
    it 'responds with 200' do
      get health_check_path
      expect(response).to have_http_status(200)
    end
  end
end
