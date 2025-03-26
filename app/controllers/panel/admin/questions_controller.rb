class Panel::Admin::QuestionsController < PanelBaseController
  before_action :set_question, only: [ :edit, :update, :destroy ]
  before_action :get_subjects, only: [ :new, :edit ]

  def index
      @questions = Question.includes(:subject).page(params[:page])
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
