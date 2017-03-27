class Statement < ApplicationRecord
  belongs_to :company, optional: true
  # Why optional: true
  # https://stackoverflow.com/questions/35942464/trouble-with-accepts-nested-attributes-for-in-rails-5-0-0-beta3-api-option/36254714#36254714

  def display_date
    date_seen || created_at.to_date
  end
end
