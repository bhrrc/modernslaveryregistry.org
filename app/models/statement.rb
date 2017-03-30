class Statement < ApplicationRecord
  belongs_to :company, optional: true
  # Why optional: true
  # https://stackoverflow.com/questions/35942464/trouble-with-accepts-nested-attributes-for-in-rails-5-0-0-beta3-api-option/36254714#36254714

  validates :url, presence: true
  validates :link_on_front_page, :inclusion => { :in => [true, false] }
  validates :approved_by_board, :inclusion => { :in => ['Yes', 'No', 'Not explicit'] }
  validates :signed_by_director, :inclusion => { :in => [true, false] }

  before_create :set_date_seen

  private

  def set_date_seen
    self.date_seen ||= Date.today
  end
end
