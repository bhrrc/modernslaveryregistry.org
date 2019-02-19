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

    describe 'providing an industry in the URL parameters' do
      let(:industry) { Industry.create!(name: 'Software') }

      context 'when the industry id provided is valid' do
        it 'assigns compliance stats filtered by industry to the view' do
          expect(ComplianceStats).to receive(:new).with(industry: industry).and_return(:filtered_compliance_stats)

          get :index, params: { industry: industry.id }

          expect(assigns(:compliance_stats)).to eq(:filtered_compliance_stats)
        end
      end

      context 'when the industry id provided is invalid' do
        it 'assigns unfiltered compliance stats to the view' do
          expect(ComplianceStats).to receive(:new).with(industry: false).and_return(:unfiltered_compliance_stats)

          get :index, params: { industry: 'foo' }

          expect(assigns(:compliance_stats)).to eq(:unfiltered_compliance_stats)
        end
      end
    end
  end
end
