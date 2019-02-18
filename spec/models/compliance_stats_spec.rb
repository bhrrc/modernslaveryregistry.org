require 'rails_helper'

RSpec.describe ComplianceStats, type: :model do
  describe 'latest_published_statement_ids' do
    it 'only includes statements associated with legislations that have been marked for inclusion in these compliance stats' do
      included_legislation = Legislation.create!(include_in_compliance_stats: true,
                                                 name: 'included-legislation',
                                                 icon: 'icon')
      excluded_legislation = Legislation.create!(include_in_compliance_stats: false,
                                                 name: 'excluded-legislation',
                                                 icon: 'icon')
      company1 = Company.create!(name: 'company-1')
      company2 = Company.create!(name: 'company-2')
      included_statement = company1.statements.create!(legislations: [included_legislation],
                                                       published: true,
                                                       url: 'http://example.com')
      company2.statements.create!(legislations: [excluded_legislation], published: true, url: 'http://example.com')

      expect(ComplianceStats.latest_published_statement_ids).to contain_exactly(included_statement.id)
    end

    it 'only includes published statements' do
      included_legislation = Legislation.create!(include_in_compliance_stats: true,
                                                 name: 'included-legislation',
                                                 icon: 'icon')
      company1 = Company.create!(name: 'company-1')
      company2 = Company.create!(name: 'company-2')
      company2.statements.create!(published: false, legislations: [included_legislation], url: 'http://example.com')
      published_statement = company1.statements.create!(published: true,
                                                        legislations: [included_legislation],
                                                        url: 'http://example.com')

      expect(ComplianceStats.latest_published_statement_ids).to contain_exactly(published_statement.id)
    end

    it 'includes the latest statement for a company by ordering statements by last_year_covered where present' do
      included_legislation = Legislation.create!(include_in_compliance_stats: true,
                                                 name: 'included-legislation',
                                                 icon: 'icon')
      company1 = Company.create!(name: 'company-1')
      company1.statements.create!(last_year_covered: 2018,
                                  published: true,
                                  legislations: [included_legislation],
                                  url: 'http://example.com')
      latest_statement = company1.statements.create!(last_year_covered: 2019,
                                                     published: true,
                                                     legislations: [included_legislation],
                                                     url: 'http://example.com')

      expect(ComplianceStats.latest_published_statement_ids).to contain_exactly(latest_statement.id)
    end

    it 'includes the latest statement for a company by additionally ordering statements by date_seen to differentiate statements with the same last_year_covered value' do
      included_legislation = Legislation.create!(include_in_compliance_stats: true,
                                                 name: 'included-legislation',
                                                 icon: 'icon')
      company1 = Company.create!(name: 'company-1')
      company1.statements.create!(date_seen: Date.parse('2019-01-01'),
                                  last_year_covered: 2019,
                                  published: true,
                                  legislations: [included_legislation],
                                  url: 'http://example.com')
      recently_seen_statement = company1.statements.create!(date_seen: Date.parse('2019-02-01'),
                                                            last_year_covered: 2019,
                                                            published: true,
                                                            legislations: [included_legislation],
                                                            url: 'http://example.com')

      expect(ComplianceStats.latest_published_statement_ids).to contain_exactly(recently_seen_statement.id)
    end

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

      expect(ComplianceStats.latest_published_statement_ids).to contain_exactly(old_statement.id, new_statement.id)
    end
  end
end
