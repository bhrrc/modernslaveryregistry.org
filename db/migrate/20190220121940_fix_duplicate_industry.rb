class FixDuplicateIndustry < ActiveRecord::Migration[5.2]
  class Industry < ApplicationRecord; end

  def up
    duplicate_industry = Industry.find(3)
    correct_industry = Industry.find(2)

    companies = Company.where(industry: duplicate_industry)

    companies.update_all(industry_id: correct_industry.id)
    duplicate_industry.destroy
  end
end
