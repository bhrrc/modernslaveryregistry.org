class StatementsController < ApplicationController
  def new
    @company = Company.find(params[:company_id])
    @statement = @company.statements.build
  end

  def show
    @statement = Statement.find(params[:id])
  end

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
      :signed_by_director,
      :link_on_front_page,
      :approved_by_board
    )
  end
end
