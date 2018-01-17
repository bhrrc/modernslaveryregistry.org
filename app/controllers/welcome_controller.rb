class WelcomeController < ApplicationController
  include ApplicationHelper

  def index
    @statement_stats = StatementStats.new
    @compliance_stats = ComplianceStats.compile
  end
end
