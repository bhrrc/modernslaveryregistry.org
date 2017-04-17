class StatementsController < ApplicationController
  include ApplicationHelper

  # TODO: Get rid of this action - use nested form in CompaniesController
  def new
    @company = Company.find(params[:company_id])
    @statement = @company.statements.build
  end

  def show
    statements = admin? ? Statement : Statement.published
    @statement = statements.find(params[:id])
  end

  # TODO: Get rid of this action - use nested form in CompaniesController
  def create
    if params[:company_id]
      @company = Company.find(params[:company_id])
    else
      @company = Company.new(params[:company])
    end
    @statement = @company.statements.build(statement_params)
    if @statement.save
      redirect_to [@company, @statement]
    else
      render "companies/show"
    end
  end

  private

  def statement_params
    params.require(:statement).permit(
      :url,
      :linked_from,
      :link_on_front_page,
      :approved_by,
      :approved_by_board,
      :signed_by,
      :signed_by_director,
      :published
    )
  end
end
