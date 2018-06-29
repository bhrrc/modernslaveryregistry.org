class StatementsController < ApplicationController
  include ApplicationHelper

  def new
    @company = Company.find(params[:company_id])
    @statements = @company.published_statements
    @new_statement = Statement.new(company: @company)
  end

  def show
    @company = Company.find(params[:company_id])
    @statements = @company.published_statements
    @statement = @statements.find(params[:id])
  end

  def create
    @company = company_from_params
    @new_statement = @company.statements.build(statement_params)
    @new_statement.associate_with_user(current_user) if user_signed_in?

    if @new_statement.save
      redirect_to '/thanks'
    else
      @statements = @company.published_statements
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
