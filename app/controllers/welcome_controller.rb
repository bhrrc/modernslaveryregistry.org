class WelcomeController < ApplicationController
  include ApplicationHelper

  def index
    @stats = Statement.search(include_unpublished: false, criteria: {}).stats
    @compliance_stats = ComplianceStats.compile
  end
end
