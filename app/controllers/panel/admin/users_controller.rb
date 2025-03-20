class Panel::Admin::UsersController < PanelBaseController
  before_action :set_user, only: [:edit, :update, :destroy]
  
  def index
    @users = User.where(user_type: [0]).page(params[:page])
  end
  
  def edit
  end
  
  def update
    if @user.update(params_user)
      redirect_to panel_admin_user_path, notice: "Úsuario atualizado com sucesso"
    else
      render :edit
    end
  end
  
  def destroy
    if @user.destroy
      redirect_to panel_admin_user_path, notice: "Úsuario excluído com sucesso"
    else
      render :index
    end
  end
  
  private
    def params_user
      params.require(:user).permit(:username, :address, :email, :password, :password_confirmation)
    end

    def set_user
      @user = User.find(params[:id])
    end
end
      