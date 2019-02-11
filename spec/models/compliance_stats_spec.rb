require 'rails_helper'

RSpec.describe ComplianceStats, type: :model do
  describe 'latest_published_statement_ids' do
    it 'returns a single statement even when that statement has multiple companies' do
      company1 = Company.create!(name: 'company-1')
      company2 = Company.create!(name: 'company-2')
      legislation = Legislation.create!(include_in_compliance_stats: true, name: 'legislation', icon: 'icon')
      statement = Statement.create!(legislations: [legislation], published: true, url: 'http://example.com')

      company1.statements << statement
      company2.statements << statement

      expect(ComplianceStats.latest_published_statement_ids).to eq([statement.id])
    end

    it 'returns a the latest statement for each company even when that statement has multiple companies' do
      company1 = Company.create!(name: 'company-1')
      company2 = Company.create!(name: 'company-2')
      legislation = Legislation.create!(include_in_compliance_stats: true, name: 'legislation', icon: 'icon')
      old_statement = Statement.create!(last_year_covered: 2018,
                                        legislations: [legislation],
                                        published: true,
                                        url: 'http://example.com')
      new_statement = Statement.create!(last_year_covered: 2019,
                                        legislations: [legislation],
                                        published: true,
                                        url: 'http://example.com')

      company1.statements << [old_statement, new_statement]
      company2.statements << old_statement

      expect(ComplianceStats.latest_published_statement_ids).to eq([old_statement.id, new_statement.id])
    end
  end
end
