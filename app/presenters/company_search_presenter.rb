class CompanySearchPresenter
  attr_reader :form, :service

  def initialize(form)
    @form = form
    @service = CompanySearchService.new(form)
  end

  def result
    @result ||= service.perform
  end

  def companies
    ids = result.map do |_, companies|
      companies
    end.inject(:concat).uniq(&:id).map(&:id)
    puts "!!! #{ids.size}"
    @companies ||= Company.where(id: ids).page(form.page)
  end

  def stats
    @stats ||= result.map do |keyword, companies|
      { keyword => companies.length }
    end.reduce({ '*' => companies.length }, :merge)
  end

  def statement_count_for(company)
    return company.published_statements.count if @form.legislations.blank?

    company.published_statements.joins(:legislations).where(legislations: { id: @form.legislations }).count
  end
end
