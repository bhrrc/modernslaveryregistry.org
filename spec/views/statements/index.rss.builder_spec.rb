require 'rails_helper'
require 'rss'

RSpec.describe 'statements/index.rss.builder', type: :view do
  context 'with published statements' do
    let(:company) { instance_double('Company', name: 'name') }
    let(:statement) do
      instance_double('Statement',
                      company: company,
                      period_covered: 'period-covered',
                      created_at: Time.zone.now,
                      legislations: [double(name: 'legislation-name')],
                      verified_by: double(name: 'verified-by'),
                      date_seen: Time.zone.today)
    end

    before do
      assign(:statements, [statement])
    end

    it 'generates a valid RSS feed' do
      render

      expect { RSS::Parser.parse(rendered) }.to_not raise_error
    end
  end
end
