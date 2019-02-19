class WelcomeController < ApplicationController
  include ApplicationHelper

  def index
    @call_to_actions = CallToAction.all
    @statement_stats = StatementStats.new
    @compliance_stats = ComplianceStats.new(industry: industry_filter)
  end

  private

  def industry_filter
    return false unless params[:industry]

    Industry.find(params[:industry].to_i)
  rescue ActiveRecord::RecordNotFound
    false
  end
end
