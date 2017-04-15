require 'uri'
require 'open-uri'

class Statement < ApplicationRecord
  # Why optional: true
  # https://stackoverflow.com/questions/35942464/trouble-with-accepts-nested-attributes-for-in-rails-5-0-0-beta3-api-option/36254714#36254714
  belongs_to :company, optional: true

  belongs_to :verified_by, class_name: 'User', optional: true

  validates :url, presence: true
  validates :link_on_front_page, inclusion: { in: [true, false] }, if: :verified?
  validates :approved_by_board,  inclusion: { in: ['Yes', 'No', 'Not explicit'] }, if: :verified?
  validates :signed_by_director, inclusion: { in: [true, false] }, if: :verified?

  before_create :set_date_seen

  def verified?
    !verified_by.nil?
  end

  private

  unless ENV['no_verify_statement_urls']
    before_save do |statement|
      uri = URI(statement.url) rescue nil
      if uri.nil?
        statement.broken_url = true
        break
      end
      begin
        uri.scheme = 'https'
        open(uri, read_timeout: 10)
        statement.url = uri.to_s
        statement.broken_url = false
      rescue
        begin
          uri.scheme = 'http'
          open(uri, read_timeout: 10)
          statement.url = uri.to_s
          statement.broken_url = false
        rescue
          statement.broken_url = true
        end
      end
    end
  end

  def set_date_seen
    self.date_seen ||= Date.today
  end
end
