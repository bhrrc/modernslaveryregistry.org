require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe 'GET #index' do
    before do
      allow(CallToAction).to receive(:all).and_return(:call_to_actions)
      allow(StatementStats).to receive(:new).and_return(:statement_stats)
      allow(ComplianceStats).to receive(:new).and_return(:compliance_stats)
    end

    it 'assigns calls to action to the view' do
      get :index
      expect(assigns(:call_to_actions)).to eq(:call_to_actions)
    end

    it 'assigns statement stats to the view' do
      get :index
      expect(assigns(:statement_stats)).to eq(:statement_stats)
    end

    it 'assigns compliance stats to the view' do
      get :index
      expect(assigns(:compliance_stats)).to eq(:compliance_stats)
    end
  end
end
