require 'rails_helper'

RSpec.describe 'explore/_search_form.html.erb', type: :view do
  context 'when there are no statements' do
    before do
      assign(:statements, [])
    end

    it 'does not render a link to download statements as a CSV' do
      render
      expect(rendered).not_to have_text('Download statements')
    end
  end

  context 'when there are statements' do
    before do
      assign(:statements, [Statement.new])
      assign(:download_url, 'download-url')
    end

    it 'renders a link to download statements as a CSV' do
      render
      expect(rendered).to have_link('Download statements', href: 'download-url')
    end
  end
end
