class Panel::Admin::AdminsController < PanelBaseController
  before_action :set_admin, only: [:edit, :update, :destroy]
  before_action :verify_password, only: [:update]
  before_action :authorize_admin_access

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
    if @admin.update(permitted_user_params)
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
    def set_admin
      @admin = User.find(params[:id])
    end
end
