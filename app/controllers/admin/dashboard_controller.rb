module Admin
  class DashboardController < AdminController
    def show
      compare = ->(a, b) { a.company.name <=> b.company.name }
      @new_statements = Statement.where(published: false).includes(:company).order('created_at DESC').sort(&compare)
      @broken_urls = Statement.where(broken_url: true).includes(:company).order('created_at DESC').sort(&compare)
    end
  end
end
