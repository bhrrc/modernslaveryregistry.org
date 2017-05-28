class CompaniesController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!, only: %i[update edit]

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
    @company.statements.each { |s| s.associate_with_user current_user }
    if @company.save
      redirect_to after_save_path_for_company(@company)
    else
      # TODO: Fix rendering when there are errors
      render 'new'
    end
  end

  def update
    @company = Company.find(params[:id])
    authorize @company

    @company.assign_attributes(company_params)
    @company.statements.each { |s| s.associate_with_user current_user }

    if @company.save
      redirect_to after_save_path_for_company(@company)
    else
      render 'edit'
    end
  end

  def show
    @company = Company.find(params[:id])
    @statements = @company.statements.order('date_seen DESC')
    @new_statement = Statement.new(company: @company)
  end

  def edit
    @company = Company.find(params[:id])
    authorize @company, :update?
  end

  private

  def after_save_path_for_company(company)
    if company.statements.any?
      if admin?
        company_statement_path(company, company.newest_statement)
      else
        thanks_path
      end
    else
      company_path(company)
    end
  end

  def company_params
    params.require(:company).permit(:name, :url, :country_id, :sector_id, statements_attributes: STATEMENTS_ATTRIBUTES)
  end

  STATEMENTS_ATTRIBUTES = %i[
    id
    url
    linked_from
    link_on_front_page
    approved_by
    approved_by_board
    signed_by
    signed_by_director
    published
    contributor_email
  ].freeze
end
