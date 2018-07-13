class Page < ApplicationRecord
  acts_as_list

  validates :slug, presence: true, uniqueness: true
  validates :title, presence: true
  validates :short_title, presence: true
  validates :body_html, presence: true

  scope(:as_list, -> { order(:position) })

  def self.include_drafts(include_drafts)
    include_drafts ? all : where(published: true)
  end

  def to_param
    slug
  end

  def self.from_param(param)
    find_by!(slug: param)
  end

  def self.last_changed
    pluck(:updated_at).max
  end

  def banner?
    # Banner page was used for "in memory of". Change this regexp to make other
    # pages show up as banner.
    short_title =~ /memory/i
  end

  def numbers_explained?
    short_title =~ /numbers explained/i
  end
end
