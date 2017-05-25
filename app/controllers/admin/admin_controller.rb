module Admin
  class AdminController < ApplicationController
    include ApplicationHelper
    before_action :ensure_user_is_admin
    layout 'admin'

    private

    def ensure_user_is_admin
      raise ActionController::RoutingError, 'Not Found' unless admin?
    end
  end
end
