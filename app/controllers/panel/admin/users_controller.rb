class Panel::Admin::UsersController < PanelBaseController
  before_action :authorize_super_admin!, only: [ :new, :create ] # Apenas Super Admin pode criar usuários
  before_action :set_user, only: [ :edit, :update, :destroy, :profile ]
  before_action :verify_password, only: [ :update ]
  before_action :authorize_user_access, only: [ :edit, :update, :destroy, :profile ]

  def index
    @users =
      if params[:term].present?
        term = params[:term].to_s.downcase
        User.where("LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? ", "%#{term}%", "%#{term}%").page(params[:page])
      else
        User.all.page(params[:page])
      end
  end

  # Método que exibe o formulário de novo usuário
  def new
    authorize_super_admin! # apenas super admin pode criar usuários
    @user = User.new
  end

  # Método que cria um novo usuário com os parâmetros permitidos
  def create
    authorize_super_admin!
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Usuário criado com sucesso."
      redirect_to user_path(@user)
    else
      flash.now[:alert] = "Erro ao criar usuário."
      render :new
    end
  end

  def edit
  end

  def update
    is_self = current_user == @user
    password_being_changed = permitted_user_params[:password].present?

    if @user.update(permitted_user_params)
      # Se o usuário estiver atualizando a própria senha, reautentica e envia e-mail de confirmação
      if is_self && password_being_changed
        @user.reload
        bypass_sign_in(@user) # é um método do Devise que reautentica o usuário sem exigir login novamente.
        Devise::Mailer.password_change(@user).deliver_later
      end
      flash[:notice] = "Usuário atualizado com sucesso."
      redirect_to panel_admin_user_profile_path(@user)
    else
      flash.now[:alert] = "Erro ao atualizar o usuário."
      render :edit
    end
  end

  def destroy
    if current_user.super_admin? || current_user == @user
      @user.destroy

      if current_user == @user
        sign_out(current_user)
        redirect_to site_index_path, notice: "Sua conta foi excluída com sucesso."
      else
        redirect_to panel_admin_users_path, notice: "Conta excluída com sucesso."
      end
    else
      redirect_to panel_home_index_path, alert: "Você não tem permissão para excluir esta conta."
    end
  end

  def profile
    render :profile
  end

  # Busca de assuntos por descrição (usado na tela de questões do user comum)
  def answer
    @subjects = Subject.where("description LIKE ?", "%#{params[:term]}%").page(params[:page])
  end

  private
    # Carrega o usuário com base no parâmetro :id ou :user_id
    def set_user
      @user = User.find(params[:id] || params[:user_id])
    end

    def authorize_user_access
      if current_user.super_admin?
        # super admin: acesso total
        nil
      elsif current_user.admin_user?
        # admin: só pode editar/ver ele mesmo
        authorize_self_or_super_admin!(@user)
      elsif current_user.regular?
        # usuário comum: só pode ver/editar ele mesmo
        only_self!(@user)
      end
    end
end
