module Admin
  class CallToActionsController < AdminController
    def new
      @call_to_action = CallToAction.new
    end

    def edit
      @call_to_action = CallToAction.where(id: params[:id]).first
    end

    def index
      @call_to_actions = CallToAction.all
    end

    def create
      @call_to_action = CallToAction.new
      @call_to_action.assign_attributes(call_to_actions_params)
      if @call_to_action.save
        redirect_to %i[admin call_to_actions]
      else
        render 'new'
      end
    end

    def destroy
      CallToAction.where(id: params[:id]).first.delete
      redirect_to %i[admin call_to_actions]
    end

    def update
      @call_to_action = CallToAction.where(id: params[:id]).first
      if @call_to_action.update(call_to_actions_params)
        redirect_to %i[admin call_to_actions]
      else
        render 'edit'
      end
    end

    def call_to_actions_params
      params.require(:call_to_action).permit(:title, :body, :url, :button_text)
    end
  end
end
