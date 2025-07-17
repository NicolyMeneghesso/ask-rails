class Panel::Admin::SubjectsController < PanelBaseController
  before_action :set_subject, only: [ :edit, :update, :destroy ]
  before_action :authorize_admin_access, only: [ :new, :create, :edit, :update, :destroy, :index ] # Apenas as ações que alteram dados (CRUD) são protegida

  def index
    @subjects =
      if params[:term].present?
        term = params[:term].to_s.downcase
        Subject.where("LOWER(description) LIKE ?", "%#{term}%").page(params[:page])
      else
        Subject.includes(:questions).all.page(params[:page])
      end
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(params_subject)
    if @subject.save
      redirect_to panel_admin_subjects_path, notice: "Assunto/Área cadastrado com sucesso"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @subject.update(params_subject)
      redirect_to panel_admin_subjects_path, notice: "Assunto/Área atualizado com sucesso"
    else
      render :edit
    end
  end

  def destroy
    if @subject.destroy
      redirect_to panel_admin_subjects_path, notice: "Assunto/Área excluído com sucesso"
    else
      render :index
    end
  end

  def subjectSearch # Realiza a busca de assuntos pela descrição na interface de usuários padrão (página de questões)
    @subjects = Subject.where("description LIKE ?", "%#{params[:term]}%").page(params[:page])
  end

  private
    def params_subject
      params.require(:subject).permit(:description)
    end

    def set_subject
      @subject = Subject.find(params[:id])
    end
end
