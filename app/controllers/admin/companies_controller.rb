module Admin
  class CompaniesController < AdminController
    def index
      @companies = Company.search(params[:query]).order('updated_at desc').page(params[:page])
    end

    def new
      @company = Company.new
    end

    def edit
      @company = Company.find(params[:id])
    end

    def show
      @company = Company.find(params[:id])
    end

    def create
      @company = Company.new(company_params)
      if @company.statements.first.present? && @company.statements.first.url.blank?
        @company.statements = []
      end
      @company.associate_all_statements_with_user(current_user) if user_signed_in?
      if @company.save
        redirect_to admin_company_path(@company)
      else
        render :new
      end
    end

    def update
      @company = Company.find(params[:id])
      if @company.update_attributes(company_params)
        redirect_to admin_company_path(@company)
      else
        render :edit
      end
    end

    def destroy
      @company = Company.find(params[:id])
      @company.destroy
      redirect_to admin_companies_path
    end

    private

    def company_params
      params.require(:company).permit(:name, :country_id, :sector_id, statements_attributes: STATEMENTS_ATTRIBUTES)
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
end
