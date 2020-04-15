require 'rails_helper'

RSpec.describe CompanySearchService, type: :model do
  let!(:company) { Company.find_or_create_by name: 'Go Free Range Ltd', related_companies: 'Badgers Inc' }

  before do
    create_search_alias('Limited', 'Ltd')
    Company.reindex
  end

  describe '#perform' do
    it 'returns a result when the search term matches the company name' do
      results = CompanySearchService.new(CompanySearchForm.new(company_name: 'Go Free Range Ltd')).perform
      expect(results[:companies].size).to eq(1)
    end

    it 'returns a result when the search term matches a related company name' do
      results = CompanySearchService.new(CompanySearchForm.new(company_name: 'Badgers')).perform
      expect(results[:companies].size).to eq(1)
    end

    it 'returns a result when limited is used instead of ltd' do
      results = CompanySearchService.new(CompanySearchForm.new(company_name: 'Go Free Range Limited')).perform
      expect(results[:companies].size).to eq(1)
    end

    it 'returns a result when a partial match is used' do
      results = CompanySearchService.new(CompanySearchForm.new(company_name: 'Free Range')).perform
      expect(results[:companies].size).to eq(1)
    end

    it 'returns no results when the search terms do not match' do
      results = CompanySearchService.new(CompanySearchForm.new(company_name: 'Cucumber')).perform
      expect(results[:companies].size).to eq(0)
    end

    it 'returns all companies when no company name is provided' do
      results = CompanySearchService.new(CompanySearchForm.new).perform
      expect(results[:companies].size).to eq(1)
    end

    it 'returns all companies when a blank company name is provided' do
      results = CompanySearchService.new(CompanySearchForm.new(company_name: '')).perform
      expect(results[:companies].size).to eq(1)
    end
  end

  context 'filtering by country' do
    let(:country) { Country.create!(code: 'GB', name: 'United Kingdom') }
    let(:other_country) { Country.create!(code: 'NO', name: 'Norway') }

    before do
      company.country = country
      company.company_number = '123456'
      company.save
      Company.reindex
    end

    describe '#results' do
      context 'when the country is included in the search criteria' do
        it 'includes the company in the results' do
          results = CompanySearchService.new(CompanySearchForm.new(company_name: 'Go Free Range Ltd', countries: [country.id])).perform
          expect(results[:companies].size).to eq(1)
        end
      end

      context 'when a different country is included in the search criteria' do
        it 'excludes the company in the results' do
          results = CompanySearchService.new(CompanySearchForm.new(company_name: 'Go Free Range Ltd', countries: [other_country.id])).perform
          expect(results[:companies].size).to eq(0)
        end
      end

      context 'when no countries are included in the search criteria' do
        it 'includes the company in the results' do
          results = CompanySearchService.new(CompanySearchForm.new(company_name: 'Go Free Range Ltd')).perform
          expect(results[:companies].size).to eq(1)
        end
      end

      context 'when both countries are included in the search criteria' do
        it 'includes the company in the results' do
          results = CompanySearchService.new(CompanySearchForm.new(
            company_name: 'Go Free Range Ltd',
            countries: [country.id, other_country.id]
          )).perform
          expect(results[:companies].size).to eq(1)
        end
      end
    end
  end

  context 'filtering by industry' do
    let(:industry) { Industry.create!(name: 'Software') }
    let(:other_industry) { Industry.create!(name: 'Agriculture') }

    before do
      company.industry = industry
      company.save
      Company.reindex
    end

    describe '#results' do
      context 'when the industry is included in the search criteria' do
        it 'includes the company in the results' do
          results = CompanySearchService.new(CompanySearchForm.new(
            company_name: 'Go Free Range Ltd',
            industries: [industry.id]
          )).perform
          expect(results[:companies].size).to eq(1)
        end
      end

      context 'when a different industry is included in the search criteria' do
        it 'excludes the company in the results' do
          results = CompanySearchService.new(CompanySearchForm.new(
            company_name: 'Go Free Range Ltd',
            industries: [other_industry.id]
          )).perform
          expect(results[:companies].size).to eq(0)
        end
      end

      context 'when no industries are included in the search criteria' do
        it 'includes the company in the results' do
          results = CompanySearchService.new(CompanySearchForm.new(company_name: 'Go Free Range Ltd')).perform
          expect(results[:companies].size).to eq(1)
        end
      end

      context 'when both industries are included in the search criteria' do
        it 'includes the company in the results' do
          results = CompanySearchService.new(CompanySearchForm.new(
            company_name: 'Go Free Range Ltd',
            industries: [industry.id, other_industry.id]
          )).perform
          expect(results[:companies].size).to eq(1)
        end
      end
    end
  end

  context 'filtering by legislation' do
    let(:uk_legislation) { Legislation.create! name: Legislation::UK_NAME, icon: 'uk' }
    let(:us_legislation) { Legislation.create! name: Legislation::CALIFORNIA_NAME, icon: 'us' }

    let!(:uk_statement) do
      company.statements.create!(
        url: 'http://example.com',
        legislations: [uk_legislation],
        published: true
      )
    end

    context 'when the company has published two statements' do
      let!(:second_uk_statement) do
        company.statements.create!(
          url: 'http://example.com',
          legislations: [uk_legislation],
          published: true
        )
      end

      let(:search) do
        CompanySearchService.new(CompanySearchForm.new(
          company_name: 'Go Free Range Ltd',
          legislations: [uk_legislation.id]
        ))
      end

      before do
        Company.reindex
      end

      it 'includes the company once in the search results' do
        expect(search.perform[:companies].size).to eq(1)
      end

      # it 'returns 2 for the count of statements' do
      #   expect(search.statement_count_for(search.perform.first)).to eq(2)
      # end
    end

    describe '#results' do
      context 'when the uk legislation is included in the search criteria' do
        let(:search) do
          CompanySearchService.new(CompanySearchForm.new(
            company_name: 'Go Free Range Ltd',
            legislations: [uk_legislation.id]
          ))
        end

        before do
          Company.reindex
        end

        it 'includes the company in the results' do
          expect(search.perform[:companies].size).to eq(1)
        end

        # it 'returns 1 for the count of statements' do
        #   expect(search.statement_count_for(search.perform.first)).to eq(1)
        # end
      end

      context 'when the us legislation is included in the search criteria' do
        let(:search) do
          CompanySearchService.new(CompanySearchForm.new(
            company_name: 'Go Free Range Ltd',
            legislations: [us_legislation.id]
          ))
        end

        it 'excludes the company in the results' do
          expect(search.perform[:companies].size).to eq(0)
        end
      end

      context 'when no legislations are included in the search criteria' do
        let(:search) { CompanySearchService.new(CompanySearchForm.new(company_name: 'Go Free Range Ltd')) }

        it 'includes the company in the results' do
          expect(search.perform[:companies].size).to eq(1)
        end

        # it 'returns 1 for the count of statements' do
        #   expect(search.statement_count_for(search.perform.first)).to eq(1)
        # end
      end

      context 'when both legislations are included in the search criteria' do
        let(:search) do
          CompanySearchService.new(CompanySearchForm.new(
            company_name: 'Go Free Range Ltd',
            legislations: [uk_legislation.id, us_legislation.id]
          ))
        end

        before do
          Company.reindex
        end

        it 'includes the company in the results' do
          expect(search.perform[:companies].size).to eq(1)
        end

        # it 'returns 1 for the count of statements' do
        #   expect(search.statement_count_for(search.perform.first)).to eq(1)
        # end
      end
    end
  end

  context 'with a single statement' do
    let!(:statement) do
      company.statements.create!(
        url: 'http://example.com',
        published: true
      )
    end

    describe '#statement_count_for' do
      before do
        Company.reindex
      end

      # it 'returns a count of the statements for a company' do
      #   search = CompanySearchService.new(CompanySearchForm.new(company_name: 'Go Free Range Limited'))
      #   expect(search.statement_count_for(search.perform.first)).to eq(1)
      # end
    end
  end

  context 'with an unpublished statement' do
    let(:uk_legislation) { Legislation.create! name: Legislation::UK_NAME, icon: 'uk' }

    let!(:statement) do
      company.statements.create!(
        url: 'http://example.com',
        legislations: [uk_legislation],
        published: true
      )
    end

    let!(:unpublished_statement) do
      company.statements.create!(
        url: 'http://example.com',
        legislations: [uk_legislation],
        published: false
      )
    end

    describe '#statement_count_for' do
      before do
        Company.reindex
      end

      # it 'returns a count of the published statements for a company' do
      #   search = CompanySearchService.new(CompanySearchForm.new(company_name: 'Go Free Range Limited'))
      #   expect(search.statement_count_for(search.perform.first)).to eq(1)
      # end

      # it 'excludes unpublished statements from legislation-filtered searches' do
      #   search = CompanySearchService.new(CompanySearchForm.new(
      #     company_name: 'Go Free Range Limited',
      #     legislations: [uk_legislation.id]
      #   ))
      #   expect(search.statement_count_for(search.perform.first)).to eq(1)
      # end
    end
  end

  context 'with a statement published by another company' do
    let(:other_company) do
      Company.create! name: 'other-company'
    end

    let(:statement) do
      other_company.statements.create!(
        url: 'http://example.com',
        published: true
      )
    end

    before do
      statement.additional_companies_covered << company
    end

    describe '#statement_count_for' do
      # it 'returns a count of the statements that cover this company' do
      #   search = CompanySearchService.new(CompanySearchForm.new(company_name: 'Go Free Range Limited'))
      #   expect(search.statement_count_for(search.perform.first)).to eq(1)
      # end
    end
  end

  private

  def create_search_alias(target, substitution)
    query = "INSERT INTO search_aliases VALUES(DEFAULT, to_tsquery('#{target}'), to_tsquery('#{substitution}'));"
    ActiveRecord::Base.connection.execute(query)
  end
end
