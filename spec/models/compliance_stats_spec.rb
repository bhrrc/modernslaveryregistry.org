require 'rails_helper'

RSpec.describe ComplianceStats, type: :model do
  let(:subject) { ComplianceStats.new }

  let(:company1) { Company.create!(name: 'company-1') }
  let(:company2) { Company.create!(name: 'company-2') }

  describe '#industry' do
    it 'returns false if no industry is passed into the constructor' do
      expect(subject.industry).to be_falsey
    end

    it 'returns the industry passed into the constructor' do
      industry = Industry.new
      stats = ComplianceStats.new(industry: industry)
      expect(stats.industry).to eq(industry)
    end
  end

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
      company2.statements.create!(legislations: [legislation],
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

  context 'when a statement is associated with multiple companies in different industries' do
    let(:legislation) do
      Legislation.create!(include_in_compliance_stats: true,
                          name: 'included-legislation',
                          icon: 'icon')
    end

    let(:industry1) { Industry.create! }
    let(:industry2) { Industry.create! }

    let!(:statement) do
      company1.statements.create!(legislations: [legislation],
                                  published: true,
                                  url: 'http://example.com',
                                  approved_by_board: 'Yes',
                                  link_on_front_page: true,
                                  signed_by_director: true)
    end

    before do
      company1.update(industry: industry1)
      company2.update(industry: industry2)
      statement.additional_companies_covered << company2
    end

    context 'and generating stats for industry1' do
      let(:subject) { ComplianceStats.new(industry: industry1) }

      it 'includes a single statement in the total' do
        expect(subject.total).to eq(1)
      end

      it 'calculates the percent_fully_compliant' do
        expect(subject.percent_fully_compliant).to eq(100)
      end
    end

    context 'and generating stats for industry2' do
      let(:subject) { ComplianceStats.new(industry: industry2) }

      it 'includes a single statement in the total' do
        expect(subject.total).to eq(1)
      end

      it 'calculates the percent_fully_compliant' do
        expect(subject.percent_fully_compliant).to eq(100)
      end
    end
  end
end
