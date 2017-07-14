class PagesController < ApplicationController
  def show
    @page = Page.include_drafts(admin?).from_param(params[:id])
    raise ActionController::RoutingError, 'Not Found' if @page.nil?
  end
end
