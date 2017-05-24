require 'rails_helper'

RSpec.describe CountriesController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'loads all of the countries with companies' do
      gb = Country.create!(code: 'GB', name: 'United Kingdom')
      Country.create!(code: 'US', name: 'United States')
      Company.create!(country: gb, name: 'BigCorp')

      get :index

      expect(assigns(:countries)).to match_array([gb])
    end
  end
end
