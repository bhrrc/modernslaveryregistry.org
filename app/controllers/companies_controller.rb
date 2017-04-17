class CompaniesController < ApplicationController
  include ApplicationHelper

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
    @company.statements.each { |s| set_user_associations(s) }
    if @company.save
      if @company.statements.any?
        if admin?
          redirect_to company_statement_path(@company, @company.newest_statement)
        else
          redirect_to thanks_path
        end
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
    @company.statements.each { |s| set_user_associations(s) }

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
      :published,
      :contributor_email
    ])
  end
end
