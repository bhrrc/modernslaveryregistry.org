module Admin
  class StatsController < AdminController
    def index
      @compliance_stats = ComplianceStats.compile
    end
  end
end
