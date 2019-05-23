class CompaniesController < ApplicationController
  include ApplicationHelper

  def new
    @company = Company.new
    @company.statements.build
  end

  def create
    @company = Company.new(company_params)
    @company.associate_all_statements_with_user(current_user) if user_signed_in?
    if @company.save
      send_submission_email
      redirect_to thanks_path
    else
      @company.statements.build if @company.statements.empty?
      render 'new'
    end
  end

  def show
    @company = Company.find(params[:id])
    @statements = @company.published_statements
    @new_statement = Statement.new(company: @company)
  end

  private

  def send_submission_email
    email = @company.statements.reverse.map(&:contributor_email).compact.first
    StatementMailer.submitted(email).deliver_later if email.present?
  end

  def company_params
    params.require(:company).permit(COMPANY_ATTRIBUTES, statements_attributes: STATEMENTS_ATTRIBUTES)
  end

  COMPANY_ATTRIBUTES = %i[
    name
    country_id
    industry_id
  ].freeze

  STATEMENTS_ATTRIBUTES = %i[voc
    url
    contributor_email
  ].freeze
end
