module Admin
  class UsersController < AdminController
    def index
      @users = User.search(params[:query]).order('id desc').page(params[:page])
    end

    def create
      @user = User.new
      @user.assign_attributes(user_params)
      if @user.save
        redirect_to admin_users_path
      else
        render 'new'
      end
    end

    def edit
      @user = User.find(params[:id])
    end

    def show
      redirect_to edit_admin_user_path(User.find(params[:id]))
    end

    def destroy
      User.find(params[:id]).delete
      redirect_to admin_users_path
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_users_path
      else
        render 'edit'
      end
    end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :admin)
    end
  end
end
