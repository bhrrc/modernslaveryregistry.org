module Admin
  class StatsController < AdminController
    def index
      @compliance_stats = ComplianceStats.compile
      @statement_stats = StatementStats.new
    end
  end
end
