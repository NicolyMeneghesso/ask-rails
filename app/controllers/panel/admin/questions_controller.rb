class Panel::Admin::QuestionsController < PanelBaseController
  before_action :set_question, only: [:edit, :update, :destroy]
  
  def index
      @questions = Question.all.page(params[:page])
  end
  
  def edit
  end
  
  def new
      @question = Question.new
  end
  
  def create
    @question = Question.new(params_question)
    if @question.save
      redirect_to panel_admin_question_path, notice: "Pergunta cadastrado com sucesso"
    else
      render :new
    end
  end
  
  def update
    if @question.update(params_question)
      redirect_to panel_admin_questions_path, notice: "Pergunta atualizado com sucesso"
    else
      render :edit
    end
  end
  
  def destroy
    if @question.destroy
      redirect_to panel_admin_questions_path, notice: "Pergunta excluído com sucesso"
    else
      render :index
    end
  end
  
  private
    def params_question
      params.require(:question).permit(:description, :subject_id)
    end

    def set_question
      @question = Question.find(params[:id])
    end
end
      
