class StatementsController < ApplicationController
  def create
    @company = Company.find(params[:company_id])
    @statement = @company.statements.build(statement_params)
    if @statement.save
      redirect_to @statement.company
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
