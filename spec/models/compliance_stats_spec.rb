require 'rails_helper'

RSpec.describe ComplianceStats, type: :model do
  let(:subject) { ComplianceStats.new }

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

      expect(subject.latest_published_statement_ids).to contain_exactly(included_statement.id)
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

      expect(subject.latest_published_statement_ids).to contain_exactly(published_statement.id)
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

      expect(subject.latest_published_statement_ids).to contain_exactly(latest_statement.id)
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

      expect(subject.latest_published_statement_ids).to contain_exactly(recently_seen_statement.id)
    end
  end
end
