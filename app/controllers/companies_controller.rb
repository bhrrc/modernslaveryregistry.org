class CompaniesController < ApplicationController
  before_action :authenticate_user!, :only => [:update, :edit]

  def new
    @company = Company.new
  end

  def new_statement
    @company = Company.new
    @company.statements.build
    render 'new'
  end

  def create
    @company = Company.new(company_params)
    @company.statements.each { |s| set_verified_by(s) }
    if @company.save
      if @company.statements.any?
        redirect_to company_statement_path(@company, @company.newest_statement)
      else
        redirect_to company_path(@company)
      end
    else
      # TODO: Fix rendering when there are errors
      render "new"
    end
  end

  def update
    @company = Company.find(params[:id])
    authorize @company

    @company.assign_attributes(company_params)
    @company.statements.each { |s| set_verified_by(s) }

    if @company.save
      if @company.statements.any?
        redirect_to company_statement_path(@company, @company.newest_statement)
      else
        redirect_to company_path(@company)
      end
    else
      render "edit"
    end
  end

  def show
    @company = Company.find(params[:id])
    @new_statement = Statement.new(company: @company)
  end

  def edit
    @company = Company.find(params[:id])
    authorize @company, :update?
  end

  private

  def set_verified_by(statement)
    statement.verified_by = statement.published? ? current_user : nil
  end

  def company_params
    params.require(:company).permit(:name, :url, :country_id, :sector_id, statements_attributes: [
      :id,
      :url,
      :linked_from,
      :link_on_front_page,
      :approved_by,
      :approved_by_board,
      :signed_by,
      :signed_by_director,
      :published
    ])
  end
end
