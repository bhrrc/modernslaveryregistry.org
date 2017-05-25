class PagesController < ApplicationController
  def show
    @page = Page.from_param(params[:id])
    raise ActionController::RoutingError, 'Not Found' if @page.nil?
  end
end
