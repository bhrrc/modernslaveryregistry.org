require 'rails_helper'

RSpec.describe Snapshot, type: :model do
  it 'prefers to display the screenshot if available' do
    snapshot = Snapshot.new
    snapshot.content_data = 'original-content-data'
    snapshot.content_type = 'original-content-type'
    snapshot.image_content_data = 'screenshot-content-data'
    snapshot.image_content_type = 'screenshot-content-type'

    expect(snapshot.data_for_display).to eq('screenshot-content-data')
    expect(snapshot.content_type_for_display).to eq('screenshot-content-type')
  end

  it 'falls back to the original content if screenshot is not available' do
    snapshot = Snapshot.new
    snapshot.content_data = 'original-content-data'
    snapshot.content_type = 'original-content-type'

    expect(snapshot.data_for_display).to eq('original-content-data')
    expect(snapshot.content_type_for_display).to eq('original-content-type')
  end
end
