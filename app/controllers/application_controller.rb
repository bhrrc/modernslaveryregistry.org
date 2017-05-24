class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception, prepend: true

  layout :layout_by_resource

  def after_sign_in_path_for(user)
    stored_location_for(user) || default_after_sign_in_path_for(user)
  end

  private

  def default_after_sign_in_path_for(user)
    user.admin? ? admin_root_path : root_path
  end

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end
end
