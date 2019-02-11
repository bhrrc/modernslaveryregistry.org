module Admin
  class DashboardController < AdminController
    def show # rubocop:disable Metrics/AbcSize
      compare = ->(a, b) { a.company.name <=> b.company.name }
      @new_statements = Statement.where(published: false).includes(:companies).order('created_at DESC').sort(&compare)
      @broken_urls = Statement.where(broken_url: true).includes(:companies).order('created_at DESC').sort(&compare)
      @compliance_stats = ComplianceStats.compile
    end
  end
end
