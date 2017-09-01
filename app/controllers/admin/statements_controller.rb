module Admin
  class StatementsController < AdminController
    def edit
      @company = Company.find(params[:company_id])
      @statement = @company.statements.find(params[:id])
    end

    def show
      @statement = Statement.find(params[:id])
    end

    def new
      @company = Company.find(params[:company_id])
      @statement = @company.statements.build
    end

    def create
      @company = Company.find(params[:company_id])
      @statement = @company.statements.build(statement_params)
      if @statement.save
        redirect_to admin_company_path(@company)
      else
        render :new
      end
    end

    def snapshot
      @company = Company.find(params[:company_id])
      @statement = @company.statements.find(params[:id])
      @statement.fetch_snapshot
      @statement.save!
      redirect_to [:admin, @company, @statement]
    end

    def destroy
      @company = Company.find(params[:company_id])
      @company.statements.destroy(params[:id])
      redirect_to [:admin, @company]
    end

    def update
      @company = Company.find(params[:company_id])
      @statement = @company.statements.find(params[:id])
      if @statement.update_attributes(statement_params)
        @statement.associate_with_user current_user
        @statement.save!
        redirect_to admin_company_path(@company)
      else
        render :edit
      end
    end

    def mark_url_not_broken
      @company = Company.find(params[:company_id])
      @statement = @company.statements.find(params[:id])
      @statement.update!(broken_url: false, marked_not_broken_url: true)
      redirect_to [:admin, @company, @statement]
    end

    private

    def statement_params
      params.require(:statement).permit(STATEMENT_ATTRIBUTES)
    end

    STATEMENT_ATTRIBUTES = %i[
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
