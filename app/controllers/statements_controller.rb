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

  def destroy
    unless admin?
      render status: :forbidden, text: "Sorry, can't do that"
      return
    end
    statement = Statement.destroy(params[:id])
    flash[:notice] = "Deleted statement for #{statement.company.name}"
    redirect_to root_path
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

  def mark_url_not_broken
    unless admin?
      render status: :forbidden, text: "Sorry, can't do that"
      return
    end
    @company = company_from_params
    @statement = @company.statements.find(params[:id])
    @statement.update!(broken_url: false, marked_not_broken_url: true)
    redirect_to [@company, @statement]
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
