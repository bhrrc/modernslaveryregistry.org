class AddSpecialCaseIndustries < ActiveRecord::Migration[5.0]
  def up
    [
      {
        "sector_name": nil,
        "sector_code": nil,
        "industry_group_name": nil,
        "industry_group_code": nil,
        "industry_name": "Charity/Non-Profit",
        "industry_code": nil
      },
      {
        "sector_name": nil,
        "sector_code": nil,
        "industry_group_name": nil,
        "industry_group_code": nil,
        "industry_name": "Public Entities",
        "industry_code": nil
      }
    ].each do |row|
      Industry.create!(row)
    end
  end
end
