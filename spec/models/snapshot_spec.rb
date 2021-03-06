require 'rails_helper'

RSpec.describe Snapshot, type: :model do
  it 'prefers to display the screenshot if available' do
    snapshot = Snapshot.new
    snapshot.original.attach(
      io: StringIO.new('original-in-active-storage'),
      filename: 'original.html'
    )
    snapshot.screenshot.attach(
      io: StringIO.new('screenshot-in-active-storage'),
      filename: 'screenshot.png'
    )

    expect(snapshot.screenshot_or_original.download).to eq('screenshot-in-active-storage')
    expect(snapshot.screenshot_or_original.content_type).to eq('image/png')
  end

  it 'falls back to the original content if screenshot is not available' do
    snapshot = Snapshot.new
    snapshot.original.attach(
      io: StringIO.new('original-in-active-storage'),
      filename: 'original.html'
    )

    expect(snapshot.screenshot_or_original.download).to eq('original-in-active-storage')
    expect(snapshot.screenshot_or_original.content_type).to eq('text/html')
  end
end
