module Admin
  class PagesController < AdminController
    def new
      @page = Page.new
    end

    def edit
      @page = Page.from_param(params[:id])
    end

    def index
      @pages = Page.as_list
    end

    def create
      @page = Page.new
      @page.assign_attributes(pages_params)
      if @page.save
        redirect_to %i[admin pages]
      else
        render 'new'
      end
    end

    def destroy
      Page.from_param(params[:id]).delete
      redirect_to %i[admin pages]
    end

    def update
      @page = Page.from_param(params[:id])
      if @page.update(pages_params)
        redirect_to %i[admin pages]
      else
        render 'edit'
      end
    end

    def pages_params
      params.require(:page).permit(:position, :slug, :title, :short_title, :body_html)
    end
  end
end
