class Panel::Admin::UsersController < PanelBaseController
  before_action :set_user, only: [ :edit, :update, :destroy, :profile ]
  before_action :verify_password, only: [ :update ]
  before_action :authorize_admin_access, except: [ :profile, :answer, :update ] # Todas as ações exigem ser admin, exceto profile e answer
  before_action :authorize_profile_admin, only: [ :profile ] # Garante que o usuário só possa acessar o próprio perfil.

  def index
    @users = User.where(user_type: [ 0 ]).page(params[:page])
  end

  def edit
  end

  # Método que exibe o formulário
  def new
    @user = User.new
  end

  # Método que processa a submissão do formulário
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Usuário criado com sucesso."
      redirect_to user_path(@user)
    else
      flash.now[:alert] = "Erro ao criar usuário."
      render :new
    end
  end

  def update
    if @user.update(permitted_user_params)
      flash[:notice] = "Usuário atualizado com sucesso."
      redirect_to panel_admin_user_profile_path(@user)
    else
      flash.now[:alert] = "Erro ao atualizar o usuário."
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = "Úsuario excluído com sucesso"
      redirect_to panel_admin_user_path, notice: "Úsuario excluído com sucesso"
    else
      flash.now[:alert] = "Erro ao excluir o usuário."
      render :index
    end
  end

  def profile
  end

  def answer # Realiza a busca de assuntos pela descrição na interface de usuários padrão (página de questões), e o search
    @subjects = Subject.where("description LIKE ?", "%#{params[:term]}%").page(params[:page])
  end

  private
    # busca um usuário a partir do parâmetro id e o armazena em @user, ele so executa a ações depois de passar pelas outras verificaões
    def set_user
      @user = User.find(params[:id] || params[:user_id])
    end

    # Garante que o usuário só possa acessar o próprio perfil, evitando que o usuario logado acesse o perfil de outro usuario
    def authorize_profile_admin
      unless current_user == @user
        redirect_to panel_home_index_path
      end
    end
end
