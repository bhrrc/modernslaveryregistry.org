class Page < ApplicationRecord
  acts_as_list

  validates :slug, presence: true, uniqueness: true
  validates :title, presence: true
  validates :short_title, presence: true
  validates :body_html, presence: true

  scope(:as_list, -> { order(:position) })

  def to_param
    slug
  end

  def self.from_param(param)
    find_by!(slug: param)
  end
end
