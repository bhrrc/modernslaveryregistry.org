require 'rails_helper'

RSpec.describe Admin::StatsController, type: :controller do
  before(:each) do
    admin = User.create!(first_name: 'Admin', admin: true, email: 'admin@example.com', password: 'password')
    admin.confirm
    sign_in admin
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to be_successful
    end
  end
end
