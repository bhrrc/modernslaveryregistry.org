class ApplicationController < ActionController::Base
  include Pundit
  include ApplicationHelper
  protect_from_forgery with: :exception, prepend: true

  layout :layout_by_resource

  before_action :sample_requests_for_scout

  def after_sign_in_path_for(user)
    stored_location_for(user) || default_after_sign_in_path_for(user)
  end

  private

  def default_after_sign_in_path_for(user)
    user.admin? ? admin_dashboard_path : root_path
  end

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end

  def sample_requests_for_scout
    # Sample rate should range from 0-1:
    # * 0: captures no requests
    # * 0.70: captures 70% of requests
    # * 1: captures all requests
    sample_rate = 0.70
  
    if rand > sample_rate
      Rails.logger.debug("[Scout] Ignoring request: #{request.original_url}")
      ScoutApm::Transaction.ignore!
    end
  end
  
end
