class Snapshot < ApplicationRecord
  belongs_to :statement, optional: true

  def html?
    content_type =~ /html/
  end
end
