class AddLatestStatementForComplianceStatsToCompany < ActiveRecord::Migration[5.2]
  class Company < ActiveRecord::Base
    has_many :statements
    belongs_to :latest_statement_for_compliance_stats, class_name: 'Statement'
  end

  class Statement < ActiveRecord::Base
    has_many :legislation_statements, dependent: :destroy
    has_many :legislations, through: :legislation_statements
  end

  class LegislationStatement < ActiveRecord::Base
    belongs_to :legislation, inverse_of: :legislation_statements
    belongs_to :statement, inverse_of: :legislation_statements
  end

  class Legislation < ActiveRecord::Base
  end

  def up
    add_reference :companies, :latest_statement_for_compliance_stats

    Company.reset_column_information

    Company.find_each do |company|
      latest_statement_for_compliance_stats = company.statements
                                              .joins(:legislations)
                                              .where(published: true)
                                              .where('legislations.include_in_compliance_stats': true)
                                              .order('last_year_covered DESC NULLS LAST', date_seen: :desc)
                                              .limit(1).first
      company.update(latest_statement_for_compliance_stats: latest_statement_for_compliance_stats)
    end
  end

  def down
    remove_reference :companies, :latest_statement_for_compliance_stats
  end
end
