class Industry < ApplicationRecord
  def deep_name
    "#{sector_name} > #{industry_group_name} > #{industry_name}"
  end
end
