class ExploreController < ApplicationController
  include ApplicationHelper

  def index
    respond_to do |format|
      format.html do
        @download_url = build_csv_url
        @search = search
        @results = search.companies
        @compliance_stats = ComplianceStats.new
      end
      format.csv do
        headers["X-Accel-Buffering"] = "no"
        headers["Content-Type"] = "text/csv; charset=utf-8"
        headers["Content-Disposition"] =
           %(attachment; filename="#{csv_filename}")
        headers["Last-Modified"] = Time.zone.now.ctime.to_s
        headers.delete('Content-Length')
        self.response_body = ResultsExporter.to_csv(search.companies, admin?, criteria_params)
      end
    end
  end

  private

  def build_csv_url
    explore_path(params
      .to_unsafe_hash.merge(format: 'csv'))
  end

  def search
    @search ||= CompanySearchPresenter.new(CompanySearchForm.new(criteria_params))
  end

  def criteria_params
    {
      industries: params[:industries],
      countries: params[:countries],
      company_name: params[:company_name],
      legislations: params[:legislations],
      statement_keywords: params[:statement_keywords],
      include_keywords: params[:include_keywords],
      page: params[:page],
      fetch_all_records: params[:format] == 'csv'
    }
  end

  def csv_filename
    "modernslaveryregistry-#{Time.zone.today}.csv"
  end
end
