require 'rails_helper'

RSpec.describe StatementsController, type: :controller do
  describe 'GET #index' do
    before do
      allow(Statement).to receive(:most_recently_published).and_return(:statement)
    end

    it 'responds to requests for RSS' do
      get :index, format: :rss
      expect(response).to be_successful
    end

    it 'assigns statements to the view' do
      get :index, format: :rss
      expect(assigns(:statements)).to eq(:statement)
    end
  end
end
