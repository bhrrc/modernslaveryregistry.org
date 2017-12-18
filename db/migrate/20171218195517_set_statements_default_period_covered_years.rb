class SetStatementsDefaultPeriodCoveredYears < ActiveRecord::Migration[5.0]
  def up
    Company.all.each do |company|
      first_statement = company.statements.order('id').first
      if first_statement.present?
        first_statement.update_attributes!(first_year_covered: 2015, last_year_covered: 2016)
        second_statement = company.statements.order('id')[1]
        if second_statement.present?
          second_statement.update_attributes!(first_year_covered: 2016, last_year_covered: 2017)
        end
      end
    end
  end
end
