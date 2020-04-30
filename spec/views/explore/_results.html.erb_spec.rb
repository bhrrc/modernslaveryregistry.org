require 'rails_helper'

RSpec.describe 'explore/_results.html.erb', type: :view do
  context 'when there are no results' do
    before do
      assign(:results, [])
    end

    xit 'does not render a link to download results as a CSV' do
      render
      expect(rendered).not_to have_text('Download search results')
    end
  end

  context 'when there are results' do
    before do
      assign(:results, [Statement.new])
      assign(:download_url, 'download-url')
    end

    xit 'renders a link to download results as a CSV' do
      render
      expect(rendered).to have_link('Download search results', href: 'download-url')
    end
  end
end
