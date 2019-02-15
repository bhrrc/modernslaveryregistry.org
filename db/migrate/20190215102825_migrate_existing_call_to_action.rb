class MigrateExistingCallToAction < ActiveRecord::Migration[5.2]
  class CallToAction < ApplicationRecord; end

  def up
    new_cta.first_or_create
  end

  def down
    new_cta.destroy_all
  end

  private

  def new_cta
    CallToAction.where(title: 'FTSE 100 & the UK Modern Slavery Act: From Disclosure to Action',
                       url: 'https://www.business-humanrights.org/sites/default/files/FTSE%20100%20Briefing%202018.pdf',
                       button_text: 'Download report',
                       body: 'Read the third annual assessment of reporting under the Modern Slavery Act by the UK’s largest companies. Find the highest and lowest scoring companies, an analysis of trends, and examples of good practice.')
  end
end
