class Panel::Admin::UsersController < PanelBaseController
  before_action :set_user, only: [ :edit, :update, :destroy, :profile ]
  before_action :verify_password, only: [ :update ]
  before_action :authorize_admin_access, except: [ :profile, :answer ] # Todas as ações exigem ser admin, exceto profile e answer
  before_action :authorize_profile_admin, only: [ :profile ]

  def index
    @users = User.where(user_type: [ 0 ]).page(params[:page])
  end

  def edit
  end

  def new
    @users = User.new
  end

  def update
    if @user.update(permitted_user_params)
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

  def profile
  end

  def answer
    @subjects = Subject.where("description LIKE ?", "%#{params[:term]}%").page(params[:page])
  end

  private
    def set_user
      @user = User.find(params[:id] || params[:user_id])
    end

    def authorize_profile_admin
      unless current_user == @user
        redirect_to panel_home_index_path
      end
    end
end
