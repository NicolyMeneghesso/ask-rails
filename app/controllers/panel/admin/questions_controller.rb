class Panel::Admin::QuestionsController < PanelBaseController
  before_action :set_question, only: [ :edit, :update, :destroy ]
  before_action :get_subjects, only: [ :index, :new, :edit ]
  before_action :authorize_admin_access, only: [ :new, :create, :edit, :update, :destroy, :index ]

  def index
    # Carrega todas as perguntas (questions), incluindo os dados da associação 'subject'
    @questions = Question.includes(:subject).page(params[:page])
    # Se um 'subject_id' foi enviado nos parâmetros (filtro), aplica um filtro para trazer apenas as perguntas que pertencem ao assunto selecionado
    @questions = @questions.where(subject_id: params[:subject_id]) if params[:subject_id].present?
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(params_question)
    if @question.save
      redirect_to panel_admin_questions_path, notice: "Pergunta cadastrado com sucesso"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @question.update(params_question)
      if params[:question][:answers_attributes] # Verifica se há respostas sendo enviadas no params
        # Encontra a resposta que foi marcada como correta
        correct_answer_id = params[:question][:answers_attributes].values.find { |a| a["correct"] == "1" }&.dig("id")
        if correct_answer_id
          # Desmarca todas as respostas e marca apenas a escolhida como correta
          @question.answers.update_all(correct: false)
          @question.answers.find(correct_answer_id).update!(correct: true)
        end
      end
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
      params.require(:question).permit(:description, :subject_id,
          answers_attributes: [ :id, :description, :correct, :_destroy ])
    end

    def set_question
      @question = Question.find(params[:id])
    end

    def get_subjects
      @subjects = Subject.all
    end
end
