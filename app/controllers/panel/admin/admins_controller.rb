class Panel::Admin::AdminsController < PanelBaseController
  before_action :set_admin, only: [:edit, :update, :destroy]
  before_action :verify_password, only: [:update]

  def index
    @admins = User.where(user_type: [1,2]).page(params[:page])
  end

  def edit
  end

  def new
    @admin = User.new
  end

  def create
    @admin = User.new(params_admin)
    if @admin.save
      redirect_to panel_admin_admins_path, notice: "Administrador cadastrado com sucesso"
    else
      render :new
    end
  end

  def update
    if @admin.update(params_admin)
      redirect_to panel_admin_admins_path, notice: "Administrador atualizado com sucesso"
    else
      render :edit
    end
  end

  def destroy
    if @admin.destroy
      redirect_to panel_admin_admins_path, notice: "Administrador excluído com sucesso"
    else
      render :index
    end
  end

  private
    def params_admin
      params.require(:user).permit(:username, :address, :email, :password, :password_confirmation)
    end

    def set_admin
      @admin = User.find(params[:id])
    end

    def verify_password
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].extract!(:password, :password_confirmation) 
      end
    end
end
