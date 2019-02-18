class WelcomeController < ApplicationController
  include ApplicationHelper

  def index
    @call_to_actions = CallToAction.all
    @statement_stats = StatementStats.new
    @compliance_stats = ComplianceStats.new
  end
end
