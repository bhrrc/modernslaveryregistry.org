require 'snapshot'

class Snapshot < ApplicationRecord
  def original_needs_to_be_uploaded?
    content_data.present? && !original.attached?
  end

  def screenshot_needs_to_be_uploaded?
    image_content_data.present? && !screenshot.attached?
  end
end

Snapshot.find_each(batch_size: 10) do |snapshot|
  if snapshot.original_needs_to_be_uploaded?
    puts "Uploading original for snapshot #{snapshot.id}"
    snapshot.original.attach(
      io: StringIO.new(snapshot.content_data),
      filename: 'original',
      content_type: snapshot.content_type
    )
  end

  if snapshot.screenshot_needs_to_be_uploaded?
    puts "Uploading screenshot for snapshot #{snapshot.id}"
    snapshot.screenshot.attach(
      io: StringIO.new(snapshot.image_content_data),
      filename: 'original',
      content_type: snapshot.image_content_type
    )
  end
end
