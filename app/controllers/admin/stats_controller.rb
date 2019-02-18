module Admin
  class StatsController < AdminController
    def index
      @compliance_stats = ComplianceStats.new
      @statement_stats = StatementStats.new
    end
  end
end
