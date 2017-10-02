class StatementsController < ApplicationController
  include ApplicationHelper

  def new
    @company = Company.find(params[:company_id])
    @statement = @company.statements.build
  end

  def show
    statements = admin? ? Statement : Statement.published
    @statement = statements.find(params[:id])
  end

  def create
    @company = company_from_params
    @statement = @company.statements.build(statement_params)
    @statement.associate_with_user current_user

    if @statement.save
      redirect_to [@company, @statement]
    else
      render 'new'
    end
  end

  private

  def company_from_params
    params[:company_id] ? Company.find(params[:company_id]) : Company.new(params[:company])
  end

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
