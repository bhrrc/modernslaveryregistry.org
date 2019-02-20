require 'rails_helper'

RSpec.describe ComplianceStats, type: :model do
  let(:subject) { ComplianceStats.new }

  let(:company1) { Company.create!(name: 'company-1') }
  let(:company2) { Company.create!(name: 'company-2') }

  context 'when legislation is not included in stats' do
    let(:legislation) do
      Legislation.create!(include_in_compliance_stats: false,
                          name: 'excluded-legislation',
                          icon: 'icon')
    end

    let!(:statement_against_excluded_legislation) do
      company1.statements.create!(legislations: [legislation],
                                  published: true,
                                  url: 'http://example.com',
                                  approved_by_board: 'Yes',
                                  link_on_front_page: true,
                                  signed_by_director: true)
    end

    it 'calculates total as 0' do
      expect(subject.total).to eq(0)
    end

    it 'calculates approved_by_board_count as 0' do
      expect(subject.approved_by_board_count).to eq(0)
    end

    it 'calculates link_on_front_page_count as 0' do
      expect(subject.link_on_front_page_count).to eq(0)
    end

    it 'calculates signed_by_director_count as 0' do
      expect(subject.signed_by_director_count).to eq(0)
    end

    it 'calculates fully_compliant_count as 0' do
      expect(subject.fully_compliant_count).to eq(0)
    end
  end

  context 'when legislation is included in stats' do
    let(:legislation) do
      Legislation.create!(include_in_compliance_stats: true,
                          name: 'included-legislation',
                          icon: 'icon')
    end

    let!(:fully_compliant_statement) do
      company1.statements.create!(legislations: [legislation],
                                  published: true,
                                  url: 'http://example.com',
                                  approved_by_board: 'Yes',
                                  link_on_front_page: true,
                                  signed_by_director: true)
    end

    let!(:fully_incompliant_statement) do
      company2.statements.create!(legislations: [legislation],
                                  published: true,
                                  url: 'http://example.com',
                                  approved_by_board: 'No',
                                  link_on_front_page: false,
                                  signed_by_director: false)
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

  context 'when there are multiple published statements covering different years' do
    let(:legislation) do
      Legislation.create!(include_in_compliance_stats: true,
                          name: 'included-legislation',
                          icon: 'icon')
    end

    let!(:newer_statement) do
      company1.statements.create!(legislations: [legislation],
                                  published: true,
                                  url: 'http://example.com',
                                  approved_by_board: 'Yes',
                                  link_on_front_page: true,
                                  signed_by_director: true,
                                  last_year_covered: 2019)
    end

    let!(:older_statement) do
      company1.statements.create!(legislations: [legislation],
                                  published: true,
                                  url: 'http://example.com',
                                  approved_by_board: 'No',
                                  link_on_front_page: false,
                                  signed_by_director: false,
                                  last_year_covered: 2018)
    end

    it 'includes a single statement in the total' do
      expect(subject.total).to eq(1)
    end

    it 'includes the newer statement in the approved_by_board_count' do
      expect(subject.approved_by_board_count).to eq(1)
    end

    it 'includes the newer statement in the link_on_front_page_count' do
      expect(subject.link_on_front_page_count).to eq(1)
    end

    it 'includes the newer statement in the signed_by_director_count' do
      expect(subject.signed_by_director_count).to eq(1)
    end

    it 'includes the newer statement in the fully_compliant_count' do
      expect(subject.fully_compliant_count).to eq(1)
    end

    it 'calculates the percent_approved_by_board correctly' do
      expect(subject.percent_approved_by_board).to eq(100)
    end

    it 'calculates the percent_link_on_front_page' do
      expect(subject.percent_link_on_front_page).to eq(100)
    end

    it 'calculates the percent_signed_by_director' do
      expect(subject.percent_signed_by_director).to eq(100)
    end

    it 'calculates the percent_fully_compliant' do
      expect(subject.percent_fully_compliant).to eq(100)
    end
  end

  context 'when there are multiple published statements that were first seen at different times' do
    let(:legislation) do
      Legislation.create!(include_in_compliance_stats: true,
                          name: 'included-legislation',
                          icon: 'icon')
    end

    let!(:more_recently_seen_statement) do
      company1.statements.create!(legislations: [legislation],
                                  published: true,
                                  url: 'http://example.com',
                                  approved_by_board: 'Yes',
                                  link_on_front_page: true,
                                  signed_by_director: true,
                                  date_seen: Date.parse('1 Feb 2019'))
    end

    let!(:less_recently_seen_statement) do
      company1.statements.create!(legislations: [legislation],
                                  published: true,
                                  url: 'http://example.com',
                                  approved_by_board: 'No',
                                  link_on_front_page: false,
                                  signed_by_director: false,
                                  date_seen: Date.parse('1 Jan 2019'))
    end

    it 'includes a single statement in the total' do
      expect(subject.total).to eq(1)
    end

    it 'includes the more recently seen statement in the approved_by_board_count' do
      expect(subject.approved_by_board_count).to eq(1)
    end

    it 'includes the more recently seen statement in the link_on_front_page_count' do
      expect(subject.link_on_front_page_count).to eq(1)
    end

    it 'includes the more recently seen statement in the signed_by_director_count' do
      expect(subject.signed_by_director_count).to eq(1)
    end

    it 'includes the more recently seen statement in the fully_compliant_count' do
      expect(subject.fully_compliant_count).to eq(1)
    end

    it 'calculates the percent_approved_by_board correctly' do
      expect(subject.percent_approved_by_board).to eq(100)
    end

    it 'calculates the percent_link_on_front_page' do
      expect(subject.percent_link_on_front_page).to eq(100)
    end

    it 'calculates the percent_signed_by_director' do
      expect(subject.percent_signed_by_director).to eq(100)
    end

    it 'calculates the percent_fully_compliant' do
      expect(subject.percent_fully_compliant).to eq(100)
    end
  end

  context 'when requesting stats for a single industry' do
    let(:subject) { ComplianceStats.new(industry: industry1) }

    let(:legislation) do
      Legislation.create!(include_in_compliance_stats: true,
                          name: 'included-legislation',
                          icon: 'icon')
    end

    let(:industry1) { Industry.create! }
    let(:industry2) { Industry.create! }

    before do
      company1.update(industry: industry1)
      company2.update(industry: industry2)
    end

    let!(:industry1_statement) do
      company1.statements.create!(legislations: [legislation],
                                  published: true,
                                  url: 'http://example.com',
                                  approved_by_board: 'Yes',
                                  link_on_front_page: true,
                                  signed_by_director: true)
    end

    let!(:industry2_statement) do
      company1.statements.create!(legislations: [legislation],
                                  published: true,
                                  url: 'http://example.com',
                                  approved_by_board: 'No',
                                  link_on_front_page: false,
                                  signed_by_director: false)
    end

    it 'includes a single statement in the total' do
      expect(subject.total).to eq(1)
    end

    it 'includes the industry 1 statement in the approved_by_board_count' do
      expect(subject.approved_by_board_count).to eq(1)
    end

    it 'includes the industry 1 statement in the link_on_front_page_count' do
      expect(subject.link_on_front_page_count).to eq(1)
    end

    it 'includes the industry 1 statement in the signed_by_director_count' do
      expect(subject.signed_by_director_count).to eq(1)
    end

    it 'includes the industry 1 statement in the fully_compliant_count' do
      expect(subject.fully_compliant_count).to eq(1)
    end

    it 'calculates the percent_approved_by_board correctly' do
      expect(subject.percent_approved_by_board).to eq(100)
    end

    it 'calculates the percent_link_on_front_page' do
      expect(subject.percent_link_on_front_page).to eq(100)
    end

    it 'calculates the percent_signed_by_director' do
      expect(subject.percent_signed_by_director).to eq(100)
    end

    it 'calculates the percent_fully_compliant' do
      expect(subject.percent_fully_compliant).to eq(100)
    end
  end

  describe '#statements' do
    let(:software) { Industry.create! name: 'Software' }
    let(:software_company) { Company.create!(name: 'company-1', industry: software) }
    let(:other_company) { Company.create!(name: 'company-2') }
    let(:legislation) do
      Legislation.create!(include_in_compliance_stats: true,
                          name: 'included-legislation',
                          icon: 'icon')
    end
    let!(:software_company_statement) do
      software_company.statements.create!(legislations: [legislation],
                                          published: true,
                                          url: 'http://example.com',
                                          approved_by_board: 'Yes',
                                          link_on_front_page: true,
                                          signed_by_director: true)
    end
    let!(:other_company_statement) do
      other_company.statements.create!(legislations: [legislation],
                                       published: true,
                                       url: 'http://example.com',
                                       approved_by_board: 'No',
                                       link_on_front_page: false,
                                       signed_by_director: false)
    end

    it 'includes all statements' do
      expect(subject.statements).to contain_exactly(software_company_statement, other_company_statement)
    end

    context 'when an industry is provided' do
      let(:subject) { ComplianceStats.new(industry: software) }

      it 'includes only statements from companies in that industry' do
        expect(subject.statements).to contain_exactly(software_company_statement)
      end
    end
  end

  describe 'latest_published_statement_ids' do
    let(:subject) { ComplianceStats.new }

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
