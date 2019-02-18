require 'rails_helper'

RSpec.describe ComplianceStats, type: :model do
  let(:subject) { ComplianceStats.new }

  describe 'statistics' do
    let(:legislation) do
      Legislation.create!(include_in_compliance_stats: true,
                          name: 'included-legislation',
                          icon: 'icon')
    end

    let(:company1) { Company.create!(name: 'company-1') }
    let(:company2) { Company.create!(name: 'company-2') }

    let!(:fully_compliant_statement) do
      company1.statements.create!(legislations: [legislation],
                                  published: true,
                                  url: 'http://example.com',
                                  approved_by_board: 'Yes',
                                  link_on_front_page: true,
                                  signed_by_director: true
                                 )
    end

    let!(:fully_incompliant_statement) do
      company2.statements.create!(legislations: [legislation],
                                  published: true,
                                  url: 'http://example.com',
                                  approved_by_board: 'No',
                                  link_on_front_page: false,
                                  signed_by_director: false
                                 )
    end

    it 'includes both statements in the total' do
      expect(subject.total).to eq(2)
    end

    it 'includes one statement in the approved_by_board_count' do
      expect(subject.approved_by_board_count).to eq(1)
    end

    it 'includes one statement in the link_on_front_page_count' do
      expect(subject.link_on_front_page_count).to eq(1)
    end

    it 'includes one statement in the signed_by_director_count' do
      expect(subject.signed_by_director_count).to eq(1)
    end

    it 'includes one statement in the fully_compliant_count' do
      expect(subject.fully_compliant_count).to eq(1)
    end

    it 'calculates the percent_approved_by_board correctly' do
      expect(subject.percent_approved_by_board).to eq(50)
    end

    it 'calculates the percent_link_on_front_page' do
      expect(subject.percent_link_on_front_page).to eq(50)
    end

    it 'calculates the percent_signed_by_director' do
      expect(subject.percent_signed_by_director).to eq(50)
    end

    it 'calculates the percent_fully_compliant' do
      expect(subject.percent_fully_compliant).to eq(50)
    end
  end

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
