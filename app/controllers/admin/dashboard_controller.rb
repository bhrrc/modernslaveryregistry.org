module Admin
  class DashboardController < AdminController
    def show
      @new_statements = Statement.where(published: false).includes(:company).order('created_at DESC')
      @broken_urls = Statement.where(broken_url: true).includes(:company).order('created_at DESC')
      @compliance_stats = ComplianceStats.compile
    end
  end
end
