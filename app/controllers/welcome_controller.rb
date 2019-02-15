class WelcomeController < ApplicationController
  include ApplicationHelper

  def index
    @call_to_action = CallToAction.first
    @statement_stats = StatementStats.new
    @compliance_stats = ComplianceStats.compile
  end
end
