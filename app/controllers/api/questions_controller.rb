class Api::QuestionsController < ApplicationController
  # Retorna todas as questões filtradas pelo subject_id em formato JSON
  def index   # Retorna todas as questões associadas a um determinado assunto (subject_id), no formato JSON
    questions = Question.where(subject_id: params[:subject_id])
    render json: questions.to_json
  end

  def answers   # Retorna todas as respostas de uma pergunta específica (question_id), no formato JSON
    if params[:question_id].blank?
      render json: { error: "Parâmetro question_id ausente" }, status: :bad_request
      return
    end

    answers = Answer.where(question_id: params[:question_id])
    render json: answers
  end

  def answer_check   # Verifica se a resposta enviada é a correta
    if params[:answer_id].blank?
      return render json: { error: "Parâmetro answer_id ausente" }, status: :bad_request
    end
    # Busca a resposta pelo ID e retorna true/false com base no atributo `correct`
    answer_response = Answer.find(params[:answer_id])&.correct || false
    render json: { correct: answer_response }

    set_user_statistic(answer_response)
  end

  private
  # Atualiza as estatísticas do usuário com base na resposta enviada.
  def set_user_statistic(answer_response)
    user_statistic = UserStatistic.find_or_create_by(user: current_user) # Procura no banco uma estatística vinculada ao usuário logado
    if answer_response
      user_statistic.increment!(:right_questions)
    else
      user_statistic.increment!(:wrong_questions)
    end
  end
end
