class Snapshot < ApplicationRecord
  belongs_to :statement, optional: true
end
